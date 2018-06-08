//
//  CoreDataHelper.swift
//  User
//
//  Created by CSS on 07/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import CoreData

class CoreDataHelper : NSObject {
    
    let workEntity = "Work"
    let homeEntity = "Home"
    let modalName = "Model"
    
    var workObject : Work?
    var homeObject : Home?
    
    lazy var persistantContainer : NSPersistentContainer = {
        
       let container = NSPersistentContainer(name: modalName)
        container.loadPersistentStores(completionHandler: { (descriptionString, error) in
            
            if error == nil {
                print(error ?? "")
            }
            
        })
        return container
    }()
    
    // MARK:- Insert in Core Data
    
    func insert(data : LocationDetail, isWork : Bool) {
        
       let entityObject = NSEntityDescription.insertNewObject(forEntityName:  isWork ? workEntity : homeEntity, into: persistantContainer.viewContext)
        
        if isWork {
            deleteData(from: workEntity)
            let entityValue = entityObject as?  Work
            entityValue?.address = data.address
            entityValue?.latitude = data.coordinate.latitude
            entityValue?.longitude = data.coordinate.longitude
            
        } else {
            deleteData(from: homeEntity)
            let entityValue = entityObject as? Home
            entityValue?.address = data.address
            entityValue?.latitude = data.coordinate.latitude
            entityValue?.longitude = data.coordinate.longitude
            
        }
        
        self.save()
    }
    
     // MARK:- Save in Core Data
    
    private func save() {
        
        do {
            try persistantContainer.viewContext.save()
        } catch let err {
            print("Error in Saving Core Data ",err.localizedDescription)
        }
        
    }
    
     // MARK:- Retrieve in Core Data
    
    func favouriteLocation()->(work : Work?, home : Home?) {
        
        do {
            
            let workFetch =  Work.fetch()
            let homeFetch = Home.fetch()
            workFetch.returnsObjectsAsFaults = false
            homeFetch.returnsObjectsAsFaults = false
            
            let workArray = try workFetch.execute()
            let homeArray = try homeFetch.execute()
           
            return (workArray.first, homeArray.first)
        
        } catch let err {
            
            print("Fetch Error  ", err.localizedDescription)
            return (nil, nil)
        }
        
    }
    
     // MARK:- Clear Data in Core Data
    
    func deleteData(from entity : String) {
      
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistantContainer.viewContext.execute(deleteRequest)
            self.save()
        } catch let err {
            print("Core Data Delete Err ", err.localizedDescription)
        }
        
    }
    
    
}

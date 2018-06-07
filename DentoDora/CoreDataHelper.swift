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
    
    lazy var persistantContainer : NSPersistentContainer = {
        
       let container = NSPersistentContainer(name: modalName)
        container.loadPersistentStores(completionHandler: { (descriptionString, error) in
            
            if error == nil {
                print(error ?? "")
            }
            
        })
        return container
    }()
    
    
    func insert(data : LocationDetail, isWork : Bool) {
        
        let work = NSEntityDescription.insertNewObject(forEntityName: workEntity, into: persistantContainer.viewContext)
        
        print("CoreData", work)
    }
    
}

//
//  User.swift
//  User
//
//  Created by CSS on 17/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//


import Foundation

class User : NSObject, NSCoding, JSONSerializable {
    
    static var main = initializeUserData()
    
    //@objc dynamic var id = 0
    
    var id : Int?
    var name : String?

    
    init(id : Int?, name : String?){
                
        self.id = id
        self.name = name
      
    }
    
    convenience
    override init(){
        self.init(id: nil, name: nil)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: Keys.list.id) as? Int
        let name = aDecoder.decodeObject(forKey: Keys.list.name) as? String
        
        self.init(id: id, name: name)
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: Keys.list.id)
        aCoder.encode(self.name, forKey: Keys.list.name)
        
    }
    
    
  
   
}










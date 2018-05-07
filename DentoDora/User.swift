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
  
    var id : Int?
    var accessToken : String?
    var firstName : String?
    var lastName :String?
    var picture : String?
    var email : String?
    var mobile : String?
    
    
    init(id : Int?, accessToken : String?, firstName : String?, lastName : String?, mobile : String?, email : String?){
                
        self.id = id
        self.accessToken = accessToken
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.email = email
        
    }
    
    convenience
    override init(){
        self.init(id: nil, accessToken: nil, firstName : nil, lastName : nil, mobile : nil, email : nil)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: Keys.list.idKey) as? Int
        let accessToken = aDecoder.decodeObject(forKey: Keys.list.accessToken) as? String
        let firstName = aDecoder.decodeObject(forKey: Keys.list.firstName) as? String
        let lastName = aDecoder.decodeObject(forKey: Keys.list.lastName) as? String
        let mobile = aDecoder.decodeObject(forKey: Keys.list.mobile) as? String
        let email = aDecoder.decodeObject(forKey: Keys.list.email) as? String
        self.init(id: id, accessToken : accessToken, firstName : firstName, lastName : lastName, mobile : mobile, email: email)
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: Keys.list.idKey)
        aCoder.encode(self.accessToken, forKey: Keys.list.accessToken)
        aCoder.encode(self.firstName, forKey: Keys.list.firstName)
        aCoder.encode(self.lastName, forKey: Keys.list.lastName)
        aCoder.encode(self.mobile, forKey: Keys.list.mobile)
        aCoder.encode(self.email, forKey: Keys.list.email)
        
    }
    
    
  
   
}










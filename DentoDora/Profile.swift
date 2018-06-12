//
//  Profile.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class Profile : JSONSerializable {
    
    var id : Int?
    var first_name : String?
    var last_name : String?
    var email : String?
    var mobile : String?
    var picture : String?
    var device_token : String?
    var access_token : String?
    var currency : String?
    
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decode(Int.self, forKey: .id)
        first_name = try? values.decode(String.self, forKey: .first_name)
        last_name = try? values.decode(String.self, forKey: .last_name)
        email = try? values.decode(String.self, forKey: .email)
        picture = try? values.decode(String.self, forKey: .id)
        device_token = try? values.decode(String.self, forKey: .id)
        access_token = try? values.decode(String.self, forKey: .id)
        currency = try? values.decode(String.self, forKey: .id)
        
        if let mobileInt = try? values.decode(Int.self, forKey: .mobile) {
         mobile = "\(mobileInt)"
        } else {
         mobile = try? values.decode(String.self, forKey: .mobile)
        }
        
    }
    init() {
    }
    
}



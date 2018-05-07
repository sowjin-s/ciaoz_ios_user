//
//  UserData.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct UserData : JSONSerializable {
    
    var device_type : DeviceType?
    var device_token : String?
    var login_by : LoginType?
    var email : String?
    var mobile : Int?
    var password : String?
    var social_unique_id : String?
    var first_name : String?
    var last_name : String?
    var device_id : String?

}

//
//  SignUpEntity.swift
//  TranxitUser
//
//  Created by Suganya on 26/03/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation

class Signup : JSONSerializable {

    var device_id : String?
    var device_type : String?
    var device_token : String?
    var login_by : String?
    var email : String?
    var mobile : String?
    var password : String?
    var first_name : String?
    var last_name : String?
    var emergency_contact_no : String?
    var ic_number: String?
    var country_code: String?
    var emergency_country_code: String?
    var gender: String?
    var referral_code: String?
    var state_id: Int?
    var city_id: Int?
    var postalcode_id: Int?
}

//
//  Request.swift
//  User
//
//  Created by CSS on 31/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct Request : JSONSerializable {
    
    var s_latitude : Double?
    var s_longitude : Double?
    var d_latitude : Double?
    var d_longitude : Double?
    var service_type : Int?
    var distance : String?
    var payment_mode : PaymentType?
    var card_id : String?
    var s_address : String?
    var d_address : String?
    var use_wallet : Int?
    var schedule_date : String?
    var schedule_time : String?
    var request_id : Int?
    var current_provider : Int?
    
}


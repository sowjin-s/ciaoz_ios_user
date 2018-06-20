//
//  Payment.swift
//  User
//
//  Created by CSS on 01/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct Payment : JSONSerializable {
    
    let id : Int?
    let request_id : Int?
    let promocode_id : String?
    let payment_id : String?
    let payment_mode : String?
    let fixed : Int?
    let distance : Int?
    let commision : Int?
    let discount : Int?
    let tax : Int?
    let wallet : Int?
    let surge : Int?
    let total : Int?
    let payable : Int?
    let provider_commission : Int?
    let provider_pay : Int?
    
}

//
//  EstimateFare.swift
//  User
//
//  Created by CSS on 31/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct EstimateFare : JSONSerializable {
    
    var estimated_fare : Float?
    var distance : Float?
    var time : String?
    var surge_value : String?
    var model :String?
    var surge :Int?
    var wallet_balance : Int?
    var useWallet : Int?
}



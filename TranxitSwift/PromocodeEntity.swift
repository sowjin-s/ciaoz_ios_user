//
//  PromocodeEntity.swift
//  User
//
//  Created by CSS on 17/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct PromocodeEntity : JSONSerializable {
    var id : Int?
    var promo_code : String?
    var promo_description : String?
    var expiration : String?
    var max_amount : Float?
    var percentage : Float?
    var value : Float?
}

struct ApplyPromo: JSONSerializable {
    var amount: Float?
    var strike_out: Int?
    var free: Int?
    var estimated_fare_surge: Float?
    var promocode_id: Int?
}


struct PromoCodeList: JSONSerializable {
    var promo_list : [PromocodeEntity]?
}

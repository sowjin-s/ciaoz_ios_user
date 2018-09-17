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
}

struct PromoCodeList: JSONSerializable {
    var promo_list : [PromocodeEntity]?
}

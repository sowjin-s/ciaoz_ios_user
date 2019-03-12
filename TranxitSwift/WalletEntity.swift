//
//  WalletEntity.swift
//  User
//
//  Created by CSS on 02/08/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class WalletEntity : JSONSerializable {
    var message : String?
    var balance : Float?
    var wallet_balance : Float?
    var wallet_transation : [WalletTransaction]?
}

struct WalletTransaction : JSONSerializable {
    var amount : Float?
    var close_balance : Float?
    var transaction_alias : String?
    var created_at : String?
    var transaction_desc : String?
}


struct MolpayEntity : JSONSerializable {
    var message : String?
    var amount : String?
    var transaction_id : Int?
    var tips: Float?
    var user_request_id : Int?
}

struct walletModel : JSONSerializable {
    var wallet_amount : String?
}

struct referralModel : JSONSerializable {
    var referral_code : String?
}

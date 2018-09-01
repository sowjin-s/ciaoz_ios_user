//
//  ChatPush.swift
//  User
//
//  Created by CSS on 31/08/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct ChatPush : JSONSerializable {
    var sender : UserType?
    var user_id : Int?
    var message : String?
}

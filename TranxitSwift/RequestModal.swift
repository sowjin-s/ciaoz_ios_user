//
//  RequestModal.swift
//  User
//
//  Created by CSS on 07/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct RequestModal : JSONSerializable {
    var data : [Request]?
    var cash : Int?
    var card : Int?
}

//
//  ErrorLog.swift
//  User
//
//  Created by CSS on 02/03/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct ErrorLogger : Decodable {
    
    var error : String?
}

struct successLog: JSONSerializable {
    
    var status: Int?
    var message: String?
}

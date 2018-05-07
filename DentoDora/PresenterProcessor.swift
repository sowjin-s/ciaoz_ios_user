//
//  PresenterProcessor.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class PresenterProcessor {
    
    
    static let shared = PresenterProcessor()

    
    func success(api : Base, response : Data)->String {
        
        return .Empty
        
    }
    
    // MARK:- Send Oath
    
    func loginRequest(data : Data)->LoginRequest?{
        
        return data.getDecodedObject(from: LoginRequest.self)
    }
    
    // MARK:- Send Profile
    
    func profile(data : Data)->Profile?{
        
        return data.getDecodedObject(from: Profile.self)
    }
    
}







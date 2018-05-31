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

    func success(api : Base, response : Data)->String? {
        return response.getDecodedObject(from: DefaultMessage.self)?.message
    }
    
    // MARK:- Send Oath
    
    func loginRequest(data : Data)->LoginRequest? {
        return data.getDecodedObject(from: LoginRequest.self)
    }
    
    // MARK:- Send Profile
    
    func profile(data : Data)->Profile? {
        return data.getDecodedObject(from: Profile.self)
    }
    
    //MARK:- UserData
    
    func userData(data : Data)->UserDataResponse? {
        return data.getDecodedObject(from: ForgotResponse.self)?.user
    }
    
    //MARK:- Service List
    
    func serviceList(data : Data)->[Service] {
        return data.getDecodedObject(from: [Service].self) ?? []
    }
    
    //MARK:- Estimate Fare
    func estimateFare(data : Data)->EstimateFare? {
        return data.getDecodedObject(from: EstimateFare.self)
    }
    
    //MARK:- Send Request
    func request(data : Data)->Request?{
        return data.getDecodedObject(from: Request.self)
    }
    
}







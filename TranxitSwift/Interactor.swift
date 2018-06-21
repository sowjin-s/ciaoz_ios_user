//
//  Interactor.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

class Interactor  {
    
    var webService: PostWebServiceProtocol?
    
    var presenter: PostPresenterOutputProtocol?
    
}

//MARK:- PostInteractorInputProtocol

extension Interactor : PostInteractorInputProtocol {
    
    func send(api: Base, url: String, data: Data?, type: HttpType) {
      
        webService?.retrieve(api: api,url: url, data: data, imageData: nil, paramters: nil, type: type, completion: nil)
        
    }
    
    func send(api: Base, data: Data?, paramters: [String : Any]?, type: HttpType) {
        webService?.retrieve(api: api,url: nil, data: data, imageData: nil, paramters: paramters, type: type, completion: nil)
    }
    
    func send(api: Base, imageData: [String : Data]?, parameters: [String : Any]?) {
        webService?.retrieve(api: api,url: nil, data: nil, imageData: imageData, paramters: parameters, type: .POST, completion: nil)
    }
    
}


extension Interactor : PostInteractorOutputProtocol {

    func on(api: Base, response: Data) {
        
        switch api {
            
         case .login :
            self.presenter?.sendOath(api: api, data: response)
            
         case .getProfile, .updateProfile, .signUp:
            self.presenter?.sendProfile(api: api, data: response)
            
        case .changePassword, .resetPassword, .cancelRequest, .payNow, .locationServicePostDelete, .addPromocode, .logout, .sendRequest:
            self.presenter?.sendSuccess(api: api, data: response)
            
        case .forgotPassword:
            self.presenter?.sendUserData(api: api, data: response)
        
        case .servicesList, .getProviders:
            self.presenter?.sendServicesList(api: api, data: response)
            
        case .estimateFare:
            self.presenter?.sendEstimateFare(api: api, data: response)
        
        case .sendRequest:
            self.presenter?.sendRequest(api: api, data: response)
        
        case .historyList, .upcomingList, .pastTripDetail, .upcomingTripDetail:
            self.presenter?.sendRequestArray(api: api, data: response)
            
        case .locationService:
            self.presenter?.sendLocationService(api: api, data: response)
        
        case .walletPassbook, .couponPassbook:
            self.presenter?.sendCouponWallet(api: api, data: response)
            
        default :
            break
            
        }
        
    }
    
    func on(api: Base, error: CustomError) {
        
        presenter?.onError(api: api, error: error)
        
    }
    
    
}

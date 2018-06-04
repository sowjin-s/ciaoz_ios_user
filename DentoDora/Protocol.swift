//
//  Protocol.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

//MARK:- Web Service Protocol

protocol PostWebServiceProtocol : class {
    
    var interactor : PostInteractorOutputProtocol? {get set}
    
    var completion : ((CustomError?, Data?)->())? {get set}
    
    func retrieve(api : Base, url : String?, data : Data?, imageData: [String : Data]?, paramters : [String : Any]?, type : HttpType, completion : ((CustomError?, Data?)->())?)
    
    
}




//MARK:- Interator Input

protocol PostInteractorInputProtocol : class {
    
    var webService : PostWebServiceProtocol? {get set}
    
    func send(api : Base, data : Data?, paramters : [String : Any]?, type : HttpType)
    
    func send(api : Base, imageData : [String : Data]?, parameters: [String : Any]?)
    
    func send(api : Base, url : String, data : Data?, type : HttpType)
    
}


//MARK:- Interator Output

protocol PostInteractorOutputProtocol : class {
    
    var presenter : PostPresenterOutputProtocol? {get set}
    
    func on(api : Base, response : Data)
    
    func on(api : Base, error : CustomError)
    
}


//MARK:- Presenter Input

protocol PostPresenterInputProtocol : class {
    
    var interactor : PostInteractorInputProtocol? {get set}
    
    var controller : PostViewProtocol? {get set}
    /**
     Send POST Request
     @param api Api type to be called
     @param data HTTP Body
     */
    func post(api : Base, data : Data?)
    /**
     Send GET Request
     @param api Api type to be called
     @param parameters paramters to be send in request
     */
    
    func get(api : Base, parameters: [String : Any]?)
    
    /**
     Send GET Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     */
    
    func get(api : Base, url : String)
    
    /**
     Send POST Request
     @param api Api type to be called
     @param imageData : Image to be sent in multipart
     @param parameters : params to be sent in multipart
     */
    func post(api : Base, imageData : [String : Data]?, parameters: [String : Any]?)
    
    /**
     Send put Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func put(api : Base, url : String, data : Data?)
    
    /**
     Send delete Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func delete(api : Base, url : String, data : Data?)
    
    /**
     Send patch Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func patch(api : Base, url : String, data : Data?)
    
    /**
     Send Post Request
     @param api Api type to be called
     @param url : Custom url without base Url Eg : </api/user/{id}>
     @param data HTTP Body
     */
    func post(api : Base, url : String, data : Data?)
    
    
}


//MARK:- Presenter Output

protocol PostPresenterOutputProtocol : class {
 
    func onError(api : Base, error : CustomError)
    func sendOath(api : Base , data : Data)
    func sendProfile(api : Base, data : Data)
    func sendSuccess(api : Base, data : Data)
    func sendUserData(api : Base, data : Data)
    func sendServicesList(api : Base, data : Data)
    func sendEstimateFare(api : Base, data : Data)
    func sendRequest(api : Base, data : Data)
    func sendRequestArray(api : Base, data : Data)
    func sendLocationService(api : Base, data : Data)
    func sendCouponWallet(api : Base, data : Data)
}


//MARK: - View

protocol PostViewProtocol : class {
    
    var presenter : PostPresenterInputProtocol? {get set}

    func onError(api : Base, message : String, statusCode code : Int)
    func getOath(api : Base , data : LoginRequest?)
    func getProfile(api : Base, data : Profile?)
    func success(api : Base, message : String?)
    func getUserData(api : Base, data : UserDataResponse?)
    func getServiceList(api : Base, data : [Service])
    func getEstimateFare(api : Base, data : EstimateFare?)
    func getRequest(api : Base, data : Request?)
    func getRequestArray(api : Base, data : [Request])
    func getLocationService(api : Base, data : LocationService?)
    func getCouponWallet(api : Base, data : [CouponWallet])
}


extension PostViewProtocol {
    
    var presenter: PostPresenterInputProtocol? {
        
        get {
            presenterObject?.controller = self
            self.presenter = presenterObject
            return presenterObject
        }
        set(newValue){
            
            presenterObject = newValue
        }
        
    }
    
    
    func getOath(api : Base , data : LoginRequest?) { return }
    func getProfile(api : Base, data : Profile?) { return }
    func success(api : Base, message : String?) { return }
    func getUserData(api : Base, data : UserDataResponse?) { return }
    func getServiceList(api : Base, data : [Service]) { return }
    func getEstimateFare(api : Base, data : EstimateFare?) { return }
    func getRequest(api : Base, data : Request?) { return }
    func getRequestArray(api : Base, data : [Request]) { return }
    func getLocationService(api : Base, data : LocationService?) { return }
    func getCouponWallet(api : Base, data : [CouponWallet]) { return }

}




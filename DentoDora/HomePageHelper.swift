//
//  HomePageHelper.swift
//  User
//
//  Created by CSS on 01/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class HomePageHelper {
    
    private var timer : Timer?
    private var status : RideStatus = .none
    
    // MARK:- Start Listening for Provider Status Changes
    func startListening(on completion : @escaping ((CustomError?,Request?)->Void)) {
        
        DispatchQueue.main.async {
            self.stopListening()
            self.timer = Timer.scheduledTimer(withTimeInterval: requestCheckInterval, repeats: true, block: { (_) in
                self.getData(on: { (error, request) in
                    completion(error,request)
                })
            })
            self.timer?.fire()
        }
        
    }
    
    //MARK:- Stop Listening
    func stopListening() {
            self.timer?.invalidate()
            self.timer = nil
    }
    
    //MARK:- Get Request Data From Service
    
    private func getData(on completion : @escaping ((CustomError?,Request?)->Void)) {
        
        Webservice().retrieve(api: .checkRequest, url: nil, data: nil, imageData: nil, paramters: nil, type: .GET) { (error, data) in
            
            guard let data = data,
                let request = data.getDecodedObject(from: RequestModal.self)?.data?.first,
                request.status != self.status  else {
                    
                completion(error, nil)
                DispatchQueue.main.async {
                    self.stopListening()
                }
                return
                    
            }
            
            completion(nil, request)
           
        }
    }
    
}

fileprivate struct RequestModal : JSONSerializable {
    var data : [Request]?
    
}

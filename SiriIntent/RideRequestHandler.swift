//
//  RideRequestHandler.swift
//  SiriIntent
//
//  Created by CSS on 16/06/18.
//  Copyright © 2018 CSS. All rights reserved.
//

import Intents
import UIKit

class RideRequestHandler: NSObject, INRequestRideIntentHandling {
    
    func resolvePartySize(for intent: INRequestRideIntent, with completion: @escaping (INIntegerResolutionResult) -> Void) {
      
        switch intent.partySize {
        case .none :
            completion(.needsValue())
        case let .some(val) where val < 5:
            completion(.success(with : val))
        default:
            completion(.unsupported())
        }

    }
    
    func handle(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        
        let code : INRequestRideIntentResponseCode
        
        guard let pickUpLocation = intent.pickupLocation?.location else {
            code = .failureRequiringAppLaunch
            completion(INRequestRideIntentResponse(code: code, userActivity: .none))
            return
        }
        
        //let dropOff = intent.dropOffLocation?.location ?? pickUpLocation
        
        let status = INRideStatus()
        status.rideIdentifier = "Ide"
        status.driver = INRideDriver(phoneNumber: "9585290750", nameComponents: nil, displayName: "Jeff", image: #imageLiteral(resourceName: "men_black").inImage, rating: "2")
        status.pickupLocation = intent.pickupLocation
        status.dropOffLocation = intent.dropOffLocation
        status.phase = .confirmed
        status.estimatedPickupDate = Date()
        
        let response = INRequestRideIntentResponse(code: .success , userActivity: .none)
        response.rideStatus = status
        completion(response)
        
    }
    
    func confirm(intent: INRequestRideIntent, completion: @escaping (INRequestRideIntentResponse) -> Void) {
        
        let responseCode : INRequestRideIntentResponseCode
        
        if let location = intent.pickupLocation?.location {
            responseCode = .ready
        } else {
            responseCode = .failureRequiringAppLaunchNoServiceInArea
        }
        completion(INRequestRideIntentResponse(code: responseCode, userActivity: nil))
        
    }
    
    
    func resolvePickupLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        
        if let pickUp = intent.pickupLocation {
            completion(.success(with: pickUp))
            print(pickUp)
        } else {
            completion(.needsValue())
        }
    }
    
    func resolveDropOffLocation(for intent: INRequestRideIntent, with completion: @escaping (INPlacemarkResolutionResult) -> Void) {
        if let drop = intent.dropOffLocation {
            completion(.success(with: drop))
        } else {
            completion(.needsValue())
        }
    }

    func resolveScheduledPickupTime(for intent: INRequestRideIntent, with completion: @escaping (INDateComponentsRangeResolutionResult) -> Void) {
        
        if let date = intent.scheduledPickupTime, let dateObject = date.startDateComponents?.date, Date()<=dateObject {
            completion(.success(with: date))
        } else {
            completion(.needsValue())
        }
        
    }
    

}

//
//  ProviderLocation.swift
//  TranxitUser
//
//  Created by Ansar on 23/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import Foundation
import Firebase

//struct ProviderLocation : JSONSerializable {
//    var lat : Double?
//    var lng : Double?
//    var bearing : Double?
//}


class ProviderLocation {
    
    var lat: Double?
    var lng: Double?
    var bearing: Double?
    
    init?(from snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as? [String: Any]
        
        guard let lat = snapshotValue?["lat"] as? Double, let lng = snapshotValue?["lng"] as? Double, let bearing = snapshotValue?["bearing"] as? Double else { return nil }
        
        self.lat = lat
        self.lng = lng
        self.bearing = bearing
       
    }
    
}

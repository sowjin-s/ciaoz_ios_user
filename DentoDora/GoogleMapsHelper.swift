//
//  GoogleMapsHelper.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import GoogleMaps

typealias LocationCoordinate = CLLocationCoordinate2D
typealias LocationDetail = (address : String, coordinate :LocationCoordinate)


class GoogleMapsHelper : NSObject {
    
    var mapView : GMSMapView?
    private var locationManager : CLLocationManager?
    private var currentLocation : ((LocationCoordinate)->Void)?
    
    func getMapView(withDelegate delegate: GMSMapViewDelegate? = nil, in view : UIView, withPosition position :LocationCoordinate = defaultMapLocation, zoom : Float = 15) {
        
        
       mapView = GMSMapView(frame: view.frame)
       mapView?.delegate = delegate
       mapView?.camera = GMSCameraPosition.camera(withTarget: position, zoom: 15)
       view.addSubview(mapView!)
    }
    
    func getCurrentLocation(onReceivingLocation : @escaping ((LocationCoordinate)->Void)){
        
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestAlwaysAuthorization()
        locationManager?.distanceFilter = 50
        locationManager?.startUpdatingLocation()
        locationManager?.delegate = self
        self.currentLocation = onReceivingLocation
    }
    
    func moveTo(location : LocationCoordinate = defaultMapLocation) {
        
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
            self.mapView?.camera = GMSCameraPosition.camera(withTarget: location, zoom: 15)
        }
        CATransaction.commit()
    }
    
    
}


extension GoogleMapsHelper: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
          print("Location: \(location)")
          self.currentLocation?(location.coordinate)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager?.stopUpdatingLocation()
        print("Error: \(error)")
    }
}

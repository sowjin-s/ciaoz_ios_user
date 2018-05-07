    
//
//  AppDelegate.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        self.appearence()
        setLocalization(language: .english)
        self.google()
       // return true
       
        
         let navigationController = UINavigationController(rootViewController: Router.setWireFrame())
         navigationController.isNavigationBarHidden = true
         window?.rootViewController = navigationController
         window?.becomeKey()
         window?.makeKeyAndVisible()
         return true
    }
}

extension AppDelegate {
    
    // MARK:- Appearence
    private func appearence() {
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        var attributes = [NSAttributedStringKey : Any]()
        attributes.updateValue(UIColor.black, forKey: .foregroundColor)
        attributes.updateValue(UIFont(name: "Avenir-Medium", size: 14.0)!, forKey : NSAttributedStringKey.font)
        UINavigationBar.appearance().titleTextAttributes = attributes
        attributes.updateValue(UIFont(name: "Avenir-Medium", size: 18.0)!, forKey : NSAttributedStringKey.font)
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = attributes
        }
    }
    
    
    
}



extension AppDelegate {
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
       // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
       // Messaging.messaging().apnsToken = deviceToken
        print("Apn Token ", deviceToken.map { String(format: "%02.2hhx", $0) }.joined())
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

      
       
        
        print("Notification  :  ", notification)

        completionHandler(.newData)
        
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
         print("Error in Notification  \(error.localizedDescription)")
    }
    
    
}
    
    // MARK:- Google
    
extension AppDelegate {
    
    func google(){
        
        GMSServices.provideAPIKey(googleMapKey)
        GMSPlacesClient.provideAPIKey(googleMapKey)
        
    }
        
}
    




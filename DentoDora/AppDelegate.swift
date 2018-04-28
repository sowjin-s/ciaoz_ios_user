    
//
//  AppDelegate.swift
//  Centros_Camprios
//
//  Created by imac on 12/18/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        self.appearence()
        setLocalization(language: .english)
        return true
       
        
        let navigationController = Router.setWireFrame()
//       navigationController.isNavigationBarHidden = true
         window?.rootViewController = navigationController
         window?.becomeKey()
         window?.makeKeyAndVisible()
         self.appearence()
         return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
       
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    

    func applicationWillTerminate(_ application: UIApplication) {
        
    
    }
  
    
}

extension AppDelegate {
    
    //MARK:- Appearence
    private func appearence(){
        
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




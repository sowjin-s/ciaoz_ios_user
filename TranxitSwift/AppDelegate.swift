

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
import IQKeyboardManagerSwift
import CoreData
import Intents
import Crashlytics
import Fabric
import Firebase
import Google
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var reachability : Reachability?
    static let shared = AppDelegate()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        FirebaseApp.configure()
        self.appearence()
        setLocalization(language: .english)
        self.google()
        self.IQKeyboard()
        self.siri()
        self.registerPush(forApp: application)
        self.stripe()
         window?.rootViewController = Router.setWireFrame()
         window?.becomeKey()
         window?.makeKeyAndVisible()
         DispatchQueue.global(qos: .background).async {
            self.startReachabilityChecking()
         }
         return true
    }
    
    // MARK:- Core Data
    
    lazy var persistentContainer : NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (descriptionString, error) in
            
            print("Error in Context  ",error ?? "")
            
        })
        return container
    }()
}

extension AppDelegate {
    
    // MARK:- Appearence
    private func appearence() {
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .darkGray
        var attributes = [NSAttributedStringKey : Any]()
        attributes.updateValue(UIColor.black, forKey: .foregroundColor)
        attributes.updateValue(UIFont(name: FontCustom.Bold.rawValue, size: 16.0)!, forKey : NSAttributedStringKey.font)
        UINavigationBar.appearance().titleTextAttributes = attributes
        attributes.updateValue(UIFont(name:FontCustom.Medium.rawValue, size: 18.0)!, forKey : NSAttributedStringKey.font)
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes = attributes
        }
        
        UIPageControl.appearance().pageIndicatorTintColor = .lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = .primary
        UIPageControl.appearance().backgroundColor = .clear
        
    }
    
    
    
}



extension AppDelegate {
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
       // Auth.auth().setAPNSToken(deviceToken, type: AuthAPNSTokenType.sandbox)
       // Messaging.messaging().apnsToken = deviceToken
        deviceTokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
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
    
    private func google(){
        
        GMSServices.provideAPIKey(googleMapKey)
        GMSPlacesClient.provideAPIKey(googleMapKey)
        var error : NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[.sourceApplication] as? String,
                                                 annotation: options[.annotation])
    }
    
    private func IQKeyboard() {
        
        IQKeyboardManager.sharedManager().enable = false
    }
    
    private func siri() {
        
        if INPreferences.siriAuthorizationStatus() != .authorized {
            INPreferences.requestSiriAuthorization { (status) in
                print("Is Siri Authorized  -",status == .authorized)
            }
        }
    }
    
    //MARK:- Stripe
    
    private func stripe(){
        
        STPPaymentConfiguration.shared().publishableKey = stripePublishableKey
        
    }
}

// MARK:- Reachability

extension AppDelegate {
    
    // MARK:- Register Push
    private func registerPush(forApp application : UIApplication){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.alert, .sound]) { (granted, error) in
            
            if granted {
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK:- Offline Booking on No Internet Connection
    
    func startReachabilityChecking() {
        
        self.reachability = Reachability()
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityAction), name: NSNotification.Name.reachabilityChanged, object: nil)
      //  self.reachability?.startNotifier()
        do {
            try self.reachability?.startNotifier()
        } catch let err {
            print("Error in Reachability", err.localizedDescription)
        }
    }
    

    func stopReachability() {
        // MARK:- Stop Reachability
        self.reachability?.stopNotifier()
    }
    
    // MARK:- Reachability Action
    
    @objc private func reachabilityAction(notification : Notification) {
        
        print("Reachability \(self.reachability?.connection.description ?? .Empty)", #function)
        guard self.reachability != nil else { return }
        if self.reachability!.connection == .none && riderStatus == .none {
            if let rootView = UIApplication.shared.keyWindow?.rootViewController?.childViewControllers.last, (rootView is HomeViewController), retrieveUserData() {
                rootView.present(id: Storyboard.Ids.OfflineBookingViewController, animation: true)
            }
        } else {
            (UIApplication.topViewController() as? OfflineBookingViewController)?.dismiss(animated: true, completion: nil)
        }
    }
    
}



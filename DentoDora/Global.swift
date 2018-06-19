//
//  Global.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Foundation
import PopupDialog

var currentBundle : Bundle!

// Store Favourite Locations

typealias FavouriteLocation = (address :String,location :LocationDetail?)

var favouriteLocations = [FavouriteLocation]()

// MARK:- Store Favourite Locations

func storeFavouriteLocations(from locationService : LocationService?) {
    
    favouriteLocations.removeAll()
    
    // Append Favourite Locations to Service
    if let location = locationService?.home?.first, let address = location.address, let latiude = location.latitude, let longitude = location.longitude {
        CoreDataHelper().insert(data: LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude)), entityName: .home)
        favouriteLocations.append((Constants.string.home.localize(), LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude))))
    } else {
        favouriteLocations.append((Constants.string.home.localize(), nil))
    }
    
    if let location = locationService?.work?.first, let address = location.address, let latiude = location.latitude, let longitude = location.longitude {
        CoreDataHelper().insert(data: LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude)), entityName: .work)
        favouriteLocations.append((Constants.string.work.localize(), LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude))))
    } else {
        favouriteLocations.append((Constants.string.work.localize(), nil))
    }
    
    if let recents = locationService?.recent {
        
        for recent in recents where recent.address != nil && recent.latitude != nil && recent.longitude != nil{
        favouriteLocations.append((recent.address!, LocationDetail(recent.address!, LocationCoordinate(latitude: recent.latitude!, longitude: recent.longitude!))))
        }
    }
    
}


//MARK:- Show Alert
func showAlert(message : String?, handler : ((UIAlertAction) -> Void)? = nil)->UIAlertController{
    
    let alert = UIAlertController(title: AppName, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title:  Constants.string.OK, style: .default, handler: handler))
    alert.view.tintColor = .primary
    return alert
    
    
}


//MARK:- Show Alert With Action

 func showAlert(message : String?, okHandler : (()->Void)?, fromView : UIViewController){
    
   /* let alert = UIAlertController(title: AppName,
                                  message: message,
        preferredStyle: .alert)
    let okAction = UIAlertAction(title: Constants.string.OK, style: .default, handler: okHandler)
    
    let cancelAction = UIAlertAction(title: Constants.string.Cancel, style: .destructive, handler: nil)
    
    alert.addAction(okAction)
    alert.addAction(cancelAction)
    alert.view.tintColor = .primary */
    
    let alert = PopupDialog(title: message, message: nil)
    let okButton =  PopupDialogButton(title: Constants.string.OK.localize(), action: {
        okHandler?()
        alert.dismiss()
    })
    alert.transitionStyle = .zoomIn
    alert.addButton(okButton)
    fromView.present(alert, animated: true, completion: nil)
    
}


//MARK:- Show Alert With Action

func showAlert(message : String?, okHandler : (()->Void)?, cancelHandler : (()->Void)?, fromView : UIViewController){
    
    let alert = PopupDialog(title: message, message: nil)
    let okButton =  PopupDialogButton(title: Constants.string.OK.localize(), action: {
        okHandler?()
        alert.dismiss()
    })
    let cancelButton =  PopupDialogButton(title: Constants.string.Cancel.localize(), action: {
        cancelHandler?()
        alert.dismiss()
    })
    alert.transitionStyle = .zoomIn
    cancelButton.titleColor = .red
    okButton.titleColor = .primary
    alert.addButton(okButton)
    alert.addButton(cancelButton)
    fromView.present(alert, animated: true, completion: nil)
    
}

//MARK:- ShowLoader

internal func createActivityIndicator(_ uiView : UIView)->UIView{
    
    let container: UIView = UIView(frame: CGRect.zero)
    container.layer.frame.size = uiView.frame.size
    container.center = CGPoint(x: uiView.bounds.width/2, y: uiView.bounds.height/2)
    container.backgroundColor = UIColor(white: 0.2, alpha: 0.3)
    
    let loadingView: UIView = UIView()
    loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
    loadingView.center = container.center
    loadingView.backgroundColor = .primary//UIColor(white:0.1, alpha: 0.7)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    loadingView.layer.shadowRadius = 5
    loadingView.layer.shadowOffset = CGSize(width: 0, height: 4)
    loadingView.layer.opacity = 2
    loadingView.layer.masksToBounds = false
    loadingView.layer.shadowColor = UIColor.gray.cgColor
    
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    actInd.clipsToBounds = true
    actInd.activityIndicatorViewStyle = .whiteLarge
    
    actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    loadingView.addSubview(actInd)
    container.addSubview(loadingView)
    container.isHidden = true
    uiView.addSubview(container)
    actInd.startAnimating()
    
    return container
    
}




internal func storeInUserDefaults(){
    
    let data = NSKeyedArchiver.archivedData(withRootObject: User.main)
    UserDefaults.standard.set(data, forKey: Keys.list.userData)
    UserDefaults.standard.synchronize()
    
    print("Store in UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Failed")
}

// Retrieve from UserDefaults
internal func retrieveUserData()->Bool{
    
    if let data = UserDefaults.standard.object(forKey: Keys.list.userData) as? Data, let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
        
        User.main = userData
        
        return true
    }
    
    return false
    
}

// Clear UserDefaults
internal func clearUserDefaults(){
    
    User.main = initializeUserData()  // Clear local User Data
    UserDefaults.standard.set(nil, forKey: Keys.list.userData)
    UserDefaults.standard.removeVolatileDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    
    print("Clear UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Success")
    
}

// MARK:- Force Logout

func forceLogout(with message : String? = nil) {
    
    clearUserDefaults()
    UIApplication.shared.windows.last?.rootViewController?.popOrDismiss(animation: true)
    let navigationController = UINavigationController(rootViewController: Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchViewController))
    navigationController.isNavigationBarHidden = true
    UIApplication.shared.windows.first?.rootViewController = navigationController
    UIApplication.shared.windows.first?.makeKeyAndVisible()
    
    if message != nil {
        UIApplication.shared.windows.last?.rootViewController?.view.makeToast(message, duration: 2, position: .center, title: nil, image: nil, style: ToastStyle(), completion: nil)
    }
}


// Initialize User

internal func initializeUserData()->User
{
    return User()
}


func setLocalization(language : Language){
    
    if let path = Bundle.main.path(forResource: language.rawValue, ofType: "lproj"), let bundle = Bundle(path: path) {
        
        currentBundle = bundle
        
    } else {
        currentBundle = .main
    }
    
    
}



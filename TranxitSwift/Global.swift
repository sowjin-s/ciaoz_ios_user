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
import AudioUnit

var currentBundle : Bundle!
var selectedShortCutItem : CoreDataEntity?
var selectedLanguage : Language = .english

// Store Favourite Locations

typealias FavouriteLocation = (address :String,location :LocationDetail?)

var favouriteLocations = [FavouriteLocation]()


// MARK:- Store Favourite Locations

func storeFavouriteLocations(from locationService : LocationService?) {
    favouriteLocations.removeAll()
    let coreData = CoreDataHelper()
    // Append Favourite Locations to Service
    if let location = locationService?.home?.first, let address = location.address, let latiude = location.latitude, let longitude = location.longitude {
        coreData.insert(data: LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude)), entityName: .home)
        favouriteLocations.append((Constants.string.home.localize(), LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude))))
    } else {
        coreData.deleteData(from: CoreDataEntity.home.rawValue)
        favouriteLocations.append((Constants.string.home.localize(), nil))
    }
    
    if let location = locationService?.work?.first, let address = location.address, let latiude = location.latitude, let longitude = location.longitude {
        coreData.insert(data: LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude)), entityName: .work)
        favouriteLocations.append((Constants.string.work.localize(), LocationDetail(address, LocationCoordinate(latitude: latiude, longitude: longitude))))
    } else {
        coreData.deleteData(from: CoreDataEntity.work.rawValue)
        favouriteLocations.append((Constants.string.work.localize(), nil))
    }
    
    if let recents = locationService?.recent {
        
        for recent in recents where recent.address != nil && recent.latitude != nil && recent.longitude != nil{
        favouriteLocations.append((recent.address!, LocationDetail(recent.address!, LocationCoordinate(latitude: recent.latitude!, longitude: recent.longitude!))))
        }
    }
    
    if let others = locationService?.others {
        
        for other in others where other.address != nil && other.latitude != nil && other.longitude != nil{
            favouriteLocations.append((other.address!, LocationDetail(other.address!, LocationCoordinate(latitude: other.latitude!, longitude: other.longitude!))))
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
    actInd.style = .whiteLarge
    
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
    let groupDefaults = UserDefaults(suiteName: Keys.list.appGroup)
    groupDefaults?.set(true, forKey: Keys.list.isLoggedIn)
    UserDefaults.standard.synchronize()
    groupDefaults?.synchronize()
    print("Store in UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Failed")
}

// Retrieve from UserDefaults
internal func retrieveUserData()->Bool{
    
    if let data = UserDefaults.standard.object(forKey: Keys.list.userData) as? Data, let userData = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
        User.main = userData
    }
    return User.main.id != nil
    
}

// Clear UserDefaults
internal func clearUserDefaults(){
    
    User.main = initializeUserData()  // Clear local User Data
    UserDefaults.standard.set(nil, forKey: Keys.list.userData)
    let groupDefaults = UserDefaults(suiteName: Keys.list.appGroup)
    groupDefaults?.set(false, forKey: Keys.list.isLoggedIn)
    UserDefaults.standard.removeVolatileDomain(forName: Bundle.main.bundleIdentifier!)
    UserDefaults.standard.synchronize()
    groupDefaults?.synchronize()
    print("Clear UserDefaults--", UserDefaults.standard.value(forKey: Keys.list.userData) ?? "Success")
    
}

// MARK:- Force Logout

func forceLogout(with message : String? = nil) {
    let user = User()
    user.id = User.main.id
    Webservice().retrieve(api: .logout, url: nil, data: user.toData(), imageData: nil, paramters: nil, type: .POST, completion: nil)
    DispatchQueue.main.async { // stopping timer on unauthorized status
         HomePageHelper.shared.stopListening()
    }
    clearUserDefaults()
    UIApplication.shared.windows.last?.rootViewController?.popOrDismiss(animation: true)
    let navigationController = UINavigationController(rootViewController: Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.LaunchViewController))
    navigationController.isNavigationBarHidden = true
    UIApplication.shared.windows.first?.rootViewController = navigationController
    UIApplication.shared.windows.first?.makeKeyAndVisible()
    if message != nil {
        UIApplication.shared.keyWindow?.makeToast(message)
    }
}

// MARK:- Add Vibration

func vibrate(with vibration : Vibration) {
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
}

// Initialize User

internal func initializeUserData()->User
{
    return User()
}


func setLocalization(language : Language){
   
    if let path = Bundle.main.path(forResource: language.code, ofType: "lproj"), let bundle = Bundle(path: path) {
        
        let attribute : UISemanticContentAttribute = language == .arabic ? .forceRightToLeft : .forceLeftToRight
        UIView.appearance().semanticContentAttribute = attribute
        selectedLanguage = language
        currentBundle = bundle
        
    } else {
        currentBundle = .main
    }
}

func getCountryCallingCode(countryRegionCode:String)->String{
    let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
    let countryDialingCode = prefixCodes[countryRegionCode]
    return countryDialingCode!
}



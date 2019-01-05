//
//  User.swift
//  User
//
//  Created by CSS on 17/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//


import Foundation

class User : NSObject, NSCoding, JSONSerializable {
    
    static var main = initializeUserData()
  
    var id : Int?
    var accessToken : String?
    var firstName : String?
    var lastName :String?
    var picture : String?
    var email : String?
    var mobile : String?
    var currency : String?
    var refreshToken : String?
    var wallet_balance : Float?
    var sos : String?
    var loginType : String?
    var dispatcherNumber : String?
    var isCashAllowed : Bool
    var isCardAllowed : Bool
    var measurement : String?
    var stripeKey : String?
    var referral_count :String?
    var referral_unique_id : String?
    var referral_total_text : String?
    var referral_text : String?
    
    init(id : Int?, accessToken : String?, firstName : String?, lastName : String?, mobile : String?, email : String?, currency : String?, picture : String?, refreshToken : String?, walletBalance : Float?, sos : String?, loginType : String?, dispatcherNumber : String?, isCardAllowed : Bool, isCashAllowed : Bool, measurement : String?, stripeKey : String?,referral_count:String?,referral_unique_id:String?,referral_total_text:String?,referral_text:String?){
                
        self.id = id
        self.accessToken = accessToken
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = mobile
        self.email = email
        self.currency = currency
        self.picture = picture
        self.refreshToken = refreshToken
        self.wallet_balance = walletBalance
        self.sos = sos
        self.loginType = loginType
        self.dispatcherNumber = dispatcherNumber
        self.isCardAllowed = isCardAllowed
        self.isCashAllowed = isCashAllowed
        self.measurement = measurement
        self.stripeKey = stripeKey
        self.referral_count = referral_count
        self.referral_unique_id = referral_unique_id
        self.referral_total_text = referral_total_text
        self.referral_text = referral_text
    }
    
    convenience
    override init(){
        self.init(id: nil, accessToken: nil, firstName : nil, lastName : nil, mobile : nil, email : nil, currency : nil, picture : nil, refreshToken : nil, walletBalance : nil, sos : nil, loginType : nil,dispatcherNumber : nil, isCardAllowed: false, isCashAllowed : true, measurement : "km", stripeKey : nil,referral_count:nil,referral_unique_id:nil,referral_total_text:nil,referral_text:nil)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: Keys.list.idKey) as? Int
        let accessToken = aDecoder.decodeObject(forKey: Keys.list.accessToken) as? String
        let firstName = aDecoder.decodeObject(forKey: Keys.list.firstName) as? String
        let lastName = aDecoder.decodeObject(forKey: Keys.list.lastName) as? String
        let mobile = aDecoder.decodeObject(forKey: Keys.list.mobile) as? String
        let email = aDecoder.decodeObject(forKey: Keys.list.email) as? String
        let currency = aDecoder.decodeObject(forKey: Keys.list.currency) as? String
        let picture = aDecoder.decodeObject(forKey: Keys.list.picture) as? String
        let refreshToken = aDecoder.decodeObject(forKey: Keys.list.refreshToken) as? String
        let walletBalance = aDecoder.decodeObject(forKey: Keys.list.wallet) as? Float
        let sos = aDecoder.decodeObject(forKey: Keys.list.sos) as? String
        let loginType = aDecoder.decodeObject(forKey: Keys.list.loginType) as? String
        let dispatcherNumber = aDecoder.decodeObject(forKey: Keys.list.dispacher) as? String
        let isCardAllowed = aDecoder.decodeBool(forKey: Keys.list.card)
        let isCashAllowed = aDecoder.decodeBool(forKey: Keys.list.cash)
        let measurement = aDecoder.decodeObject(forKey: Keys.list.measurement) as? String
        let stripeKey = aDecoder.decodeObject(forKey: Keys.list.stripe) as? String
        let referral_count = aDecoder.decodeObject(forKey: Keys.list.referral_count) as? String
        let referral_unique_id = aDecoder.decodeObject(forKey: Keys.list.referral_unique_id) as? String
        let referral_text = aDecoder.decodeObject(forKey: Keys.list.referral_text) as? String
        let referral_total_text = aDecoder.decodeObject(forKey: Keys.list.referral_total_text) as? String
        
        self.init(id: id, accessToken : accessToken, firstName : firstName, lastName : lastName, mobile : mobile, email: email, currency : currency, picture : picture, refreshToken : refreshToken, walletBalance : walletBalance, sos : sos,loginType : loginType, dispatcherNumber : dispatcherNumber, isCardAllowed : isCardAllowed, isCashAllowed : isCashAllowed, measurement : measurement, stripeKey : stripeKey,referral_count:referral_count,referral_unique_id:referral_unique_id,referral_total_text:referral_total_text,referral_text:referral_text)
        
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: Keys.list.idKey)
        aCoder.encode(self.accessToken, forKey: Keys.list.accessToken)
        aCoder.encode(self.firstName, forKey: Keys.list.firstName)
        aCoder.encode(self.lastName, forKey: Keys.list.lastName)
        aCoder.encode(self.mobile, forKey: Keys.list.mobile)
        aCoder.encode(self.email, forKey: Keys.list.email)
        aCoder.encode(self.currency, forKey: Keys.list.currency)
        aCoder.encode(self.picture, forKey: Keys.list.picture)
        aCoder.encode(self.refreshToken, forKey: Keys.list.refreshToken)
        aCoder.encode(self.wallet_balance, forKey: Keys.list.wallet)
        aCoder.encode(self.sos, forKey: Keys.list.sos)
        aCoder.encode(self.loginType, forKey: Keys.list.loginType)
        aCoder.encode(self.dispatcherNumber, forKey: Keys.list.dispacher)
        aCoder.encode(self.isCashAllowed, forKey: Keys.list.cash)
        aCoder.encode(self.isCardAllowed, forKey: Keys.list.card)
        aCoder.encode(self.measurement, forKey: Keys.list.measurement)
        aCoder.encode(self.stripeKey, forKey: Keys.list.stripe)
        aCoder.encode(self.referral_unique_id , forKey: Keys.list.referral_unique_id)
        aCoder.encode(self.referral_count , forKey: Keys.list.referral_count)
        aCoder.encode(self.referral_text , forKey: Keys.list.referral_text)
        aCoder.encode(self.referral_total_text , forKey: Keys.list.referral_total_text)
    }
    
    
  
   
}










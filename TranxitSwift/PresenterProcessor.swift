//
//  PresenterProcessor.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class PresenterProcessor {

    static let shared = PresenterProcessor()

    func success(api : Base, response : Data)->String? {
        return response.getDecodedObject(from: DefaultMessage.self)?.message
    }
    
    // MARK:- Send Oath
    
    func loginRequest(data : Data)->LoginRequest? {
        return data.getDecodedObject(from: LoginRequest.self)
    }
    
    // MARK:- Send Profile
    
    func profile(data : Data)->Profile? {
        return data.getDecodedObject(from: Profile.self)
    }
    
    // MARK:- UserData
    
    func userData(data : Data)->UserDataResponse? {
        return data.getDecodedObject(from: ForgotResponse.self)?.user
    }
    
    // MARK:- Service List
    
    func serviceList(data : Data)->[Service] {
        return data.getDecodedObject(from: [Service].self) ?? []
    }
    
    // MARK:- Estimate Fare
    
    func estimateFare(data : Data)->EstimateFare? {
        return data.getDecodedObject(from: EstimateFare.self)
    }
    
    // MARK:- Send Request
    
    func request(data : Data)->Request?{
        return data.getDecodedObject(from: Request.self)
    }
    
    // MARK:- Your Trips Modal
    
    func requestArray (data : Data)->[Request] {
        return data.getDecodedObject(from: [Request].self) ?? []
    }
    
    // MARK:- Location Service
    
    func locationService(data : Data)->LocationService? {
        return data.getDecodedObject(from: LocationService.self)
    }
    
    // MARK:- Coupon Wallet
    
    func couponWallet(data : Data)->[CouponWallet]{
        return data.getDecodedObject(from: [CouponWallet].self) ?? []
    }
    
    // MARK:- Get Card
    
    func getCards(data : Data)->[CardEntity] {
        return data.getDecodedObject(from: [CardEntity].self) ?? []
    }
    
    // MARK:- Send Wallet Entity
    
    func getWalletEntity(data : Data)->WalletEntity? {
        return data.getDecodedObject(from: WalletEntity.self)
    }
    
    // MARK:- Send Promocodes
    
    func getPromocodes(data : Data)->[PromocodeEntity] {
        return data.getDecodedObject(from: [PromocodeEntity].self) ?? []
    }
    
    // MARK:- Help
    
    func getHelpAPI(data : Data)->HelpEntity? {
        return data.getDecodedObject(from: HelpEntity.self)
    }
    
    
    // MARK:- Molpay Wallet
    
    func getMolpayWalletAPI(data : Data)->MolpayEntity? {
        return data.getDecodedObject(from: MolpayEntity.self)
    }
    
    
    // MARK:- Molpay Wallet
    
    func getWalletAPI(data : Data)->walletModel? {
        return data.getDecodedObject(from: walletModel.self)
    }
    
    // MARK:- Referral
    
    func getReferralAPI(data : Data)->referralModel? {
        return data.getDecodedObject(from: referralModel.self)
    }
    
    //MARK:- Verify Mobile number
    func verifyMobile(data: Data)-> successLog?{
        return data.getDecodedObject(from: successLog.self)
    }
    
    //MARK:- Payment Types
    func payments(data: Data)-> Payment?{
        return data.getDecodedObject(from: Payment.self)
    }
    
    //MARK:- sos
    func sosDetails(data: Data)-> sosModel?{
        return data.getDecodedObject(from: sosModel.self)
    }
    
    //MARK:- sos
    func locationInfo(data: Data)-> [userLocation]?{
        return data.getDecodedObject(from: [userLocation].self)
    }
    
    //MARK:- sos
    func promo(data: Data)-> ApplyPromo?{
        return data.getDecodedObject(from: ApplyPromo.self)
    }
    
}







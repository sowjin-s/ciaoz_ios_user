//
//  RequestSelectionView.swift
//  User
//
//  Created by CSS on 19/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import os.log

class RequestSelectionView: UIView {
    
   
    @IBOutlet private weak var labelUseWalletString : UILabel!
    @IBOutlet private weak var imageViewWallet : UIImageView!
    @IBOutlet private weak var buttonScheduleRide : UIButton!
    @IBOutlet private weak var buttonRideNow : UIButton!
    @IBOutlet private weak var viewUseWallet : UIView!
    @IBOutlet private weak var ViewLadyDriver: UIView!
    @IBOutlet private weak var viewAirportFare : UIView!
    @IBOutlet weak var viewEstimateFare : UIView!
    @IBOutlet weak var viewCoupon : UIView!
    @IBOutlet private weak var labelEstimationFareString : UILabel!
    @IBOutlet private weak var labelEstimationFare : UILabel!
    @IBOutlet private weak var labelCouponFare : UILabel!
    @IBOutlet private weak var labelCouponString : UILabel!
    @IBOutlet private weak var labelPaymentMode : Label!
    @IBOutlet private weak var buttonChangePayment : UIButton!
    @IBOutlet private weak var labelAirportString : Label!
    @IBOutlet private weak var buttonViewAirportFare : UIButton!
    
    @IBOutlet private weak var buttonCoupon : UIButton!
    @IBOutlet private weak var imageViewModal : UIImageView!
    @IBOutlet private weak var viewImageModalBg : UIView!
    @IBOutlet private weak var labelWalletBalance : UILabel!
    
    @IBOutlet private weak var labelLadyDriverYes : UILabel!
    @IBOutlet private weak var labelLadyDriverNo : UILabel!
    @IBOutlet private weak var viewLadyDriverYes : UIView!
    @IBOutlet private weak var viewLadyDriverNo : UIView!
    @IBOutlet private weak var labelLadyDriver : UILabel!
    @IBOutlet private weak var imageLadyDriverNo: UIImageView!
    @IBOutlet private weak var imageLadyDriverYes : UIImageView!

    
    var scheduleAction : ((Service)->())?
    var rideNowAction : ((Service)->())?
    var airportFareAction : (()->())?
    var paymentChangeClick : ((_ completion : @escaping ((CardEntity?)->()))->Void)?
    var onclickCoupon : ((_ couponList : [PromocodeEntity],_ selected : PromocodeEntity?, _ promo : ((PromocodeEntity?)->())?)->Void)?
    var selectedCoupon : PromocodeEntity?
//    { // Selected Promocode
//        didSet{
//            /*if let percentage = selectedCoupon?.value, let maxAmount = selectedCoupon?.max_amount, let fare = self.service?.pricing?.estimated_fare{
//                let discount = fare*(percentage/100)
//                let discountAmount = discount > maxAmount ? maxAmount : discount
//                self.setEstimationFare(amount: fare-discountAmount)
//
//            } else {
//                self.setEstimationFare(amount: self.service?.pricing?.estimated_fare)
//            } */
//
//            if let strikeOut = selectedCoupon?.strike_out, strikeOut != 0 {
//                self.setEstimationFare(amount: selectedCoupon?.amount,isStrike: true)
//            } else {
//                self.setEstimationFare(amount: selectedCoupon?.amount,isStrike: false)
//            }
//        }
//    }
    
    var appliedPromo: ApplyPromo?{
        didSet{
            if let strikeOut = appliedPromo?.strike_out, strikeOut != 0 {
                self.setEstimationFare(amount: appliedPromo?.amount,isStrike: true)
            } else {
                self.setEstimationFare(amount: appliedPromo?.amount,isStrike: false)
            }
        }
    }
    
    private var availablePromocodes = [PromocodeEntity]() { // Entire Promocodes available for selection
        didSet {
            self.isPromocodeEnabled = availablePromocodes.count>0
        }
    }
    
    private var isWalletChecked = false {  // Handle Wallet
        didSet {
            self.imageViewWallet.image = isWalletChecked ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check-box-empty")
            self.service?.pricing?.useWallet = isWalletChecked ? 1 : 0
        }
    }
    private var selectedCard : CardEntity?
    var paymentType : PaymentType = .NONE {
        didSet {
            var paymentString : String = .Empty
            if paymentType == .NONE {
                paymentString = Constants.string.NA.localize()
            } else {
                paymentString = paymentType == .CASH ? PaymentType.CASH.rawValue.localize() : PaymentType.MOLPAY.rawValue.localize()
                /*paymentString = paymentType == .CASH ? PaymentType.CASH.rawValue.localize() : (self.selectedCard == nil ? PaymentType.MOLPAY.rawValue.localize() : "\("XXXX-"+String.removeNil(self.selectedCard?.last_four))")*/
            }
            let text = "\(Constants.string.payment.localize()):\(paymentString)"
            self.labelPaymentMode.text = text
            self.labelPaymentMode.attributeColor = .secondary
            self.labelPaymentMode.startLocation = ((text.count)-(paymentString.count))
            self.labelPaymentMode.length = paymentString.count
        }
    }
    
    private var isPromocodeEnabled = false {
        didSet {
            self.buttonCoupon.setTitle({
                if !isPromocodeEnabled {
                    return " \(Constants.string.NA.localize().uppercased()) "
                }else {
                    return self.selectedCoupon != nil ? " \(String.removeNil(self.selectedCoupon?.promo_code)) " : " \(Constants.string.viewCoupons.localize()) "
                }
            }(), for: .normal)
            UIView.animate(withDuration: 0.2) {
                self.buttonCoupon.layoutIfNeeded()
            }
            self.buttonCoupon.isEnabled = isPromocodeEnabled
            self.buttonCoupon.alpha = isPromocodeEnabled ? 1 : 0.7
        }
    }
    
    private var service : Service?
    
    
    var isladydriverselected: Bool = false {
        didSet{
            if isladydriverselected == true {
                imageLadyDriverYes.image = #imageLiteral(resourceName: "radioselected").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imageLadyDriverNo.image = #imageLiteral(resourceName: "uncheck_icon").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            } else {
                imageLadyDriverNo.image = #imageLiteral(resourceName: "radioselected").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imageLadyDriverYes.image = #imageLiteral(resourceName: "uncheck_icon").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.viewImageModalBg.makeRoundedCorner()
    }
}

// MARK:- Methods

extension RequestSelectionView {
    
    // MARK:- Initial Loads
    
    private func initialLoads() {
        self.backgroundColor = .clear
        self.isladydriverselected = false
        self.isWalletChecked = false
        self.ViewLadyDriver.isHidden = (User.main.gender == Gender.Male.rawValue) ? true : false
        self.localize()
        self.setDesign()
        self.viewUseWallet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.useWalletAction)))
        self.paymentType = .NONE
        self.buttonChangePayment.isHidden = false
        /*if (User.main.isCardAllowed == false){
            self.buttonChangePayment.isHidden = true
        }else {
            self.buttonChangePayment.isHidden = !(User.main.isCashAllowed || User.main.isCardAllowed)
        }*/
//        self.buttonChangePayment.isHidden = !(User.main.isCashAllowed && User.main.isCardAllowed) // Change button enabled only if both payment modes are enabled
        self.buttonChangePayment.addTarget(self, action: #selector(self.buttonChangePaymentAction), for: .touchUpInside)
        self.buttonViewAirportFare.addTarget(self, action: #selector(self.buttonAirportFareAction), for: .touchUpInside)
        self.buttonCoupon.addTarget(self, action: #selector(self.buttonCouponAction), for: .touchUpInside)
        self.viewLadyDriverYes.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLadyDriverYes(_:))))
        self.viewLadyDriverNo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapLadyDriverNo(_:))))
        self.isPromocodeEnabled = false
        self.presenter?.get(api: .promocodes, parameters: nil)
    }
    
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: buttonRideNow, isTitle: true)
        Common.setFont(to: buttonScheduleRide, isTitle:  true)
        Common.setFont(to: labelUseWalletString)
        Common.setFont(to: labelEstimationFareString, isTitle: true)
        Common.setFont(to: labelEstimationFare, isTitle: true)
        Common.setFont(to: labelCouponFare, isTitle: true)
        Common.setFont(to: labelCouponString)
        Common.setFont(to: labelPaymentMode)
        Common.setFont(to: buttonChangePayment)
        Common.setFont(to: labelAirportString)
        Common.setFont(to: buttonViewAirportFare)
        Common.setFont(to: buttonCoupon)
        Common.setFont(to: labelWalletBalance, isTitle: true)
        Common.setFont(to: labelLadyDriver)
        Common.setFont(to: labelLadyDriverYes)
        Common.setFont(to: labelLadyDriverNo)
        
    }
    
    
    // MARK:- Localize
    
    private func localize() {
        self.labelUseWalletString.text = Constants.string.useWalletAmount.localize()
        self.buttonScheduleRide.setTitle(Constants.string.scheduleRide.localize().uppercased(), for: .normal)
        self.buttonRideNow.setTitle(Constants.string.rideNow.localize().uppercased(), for: .normal)
        self.labelEstimationFareString.text = Constants.string.estimatedFare.localize()
        self.labelCouponString.text = Constants.string.coupon.localize()
        self.buttonChangePayment.setTitle(Constants.string.change.localize().uppercased(), for: .normal)
        self.labelAirportString.text = Constants.string.airportFare.localize()
        self.buttonViewAirportFare.setTitle(Constants.string.viewFare.localize().uppercased(), for: .normal)
    }
    
    
    func setValues(values : Service) {
        self.service = values
        self.viewUseWallet.isHidden = !(Float.removeNil(self.service?.pricing?.wallet_balance)>0)
        self.setEstimationFare(amount: self.service?.pricing?.estimated_fare_surge, isStrike: false)
        self.paymentType = User.main.isCashAllowed ? .CASH :( User.main.isCardAllowed ? .MOLPAY : .NONE)
        self.imageViewModal.setImage(with: values.image, placeHolder: #imageLiteral(resourceName: "CarplaceHolder"))
        self.labelWalletBalance.text = "\(String.removeNil(User.main.currency)) \(Formatter.shared.limit(string: "\(Float.removeNil(self.service?.pricing?.wallet_balance))", maximumDecimal: 2))"
    }
    
    // MARK:- Lady Driver Yes

    @objc func tapLadyDriverYes(_ sender: UITapGestureRecognizer) {
        //print("Please Help!")
        self.isladydriverselected = true
    }
    
    // MARK:- Lady Driver No

    @objc func tapLadyDriverNo(_ sender: UITapGestureRecognizer) {
        //print("Please Help!")
        self.isladydriverselected = false
    }
    
    func setEstimationFare(amount : Float?,isStrike: Bool?) {
        //self.labelEstimationFare.text = "\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(amount ?? 0)", maximumDecimal: 2))"
        var attrStr = NSMutableAttributedString()
        if isStrike! { //if promoAmount more than estimated fare
            
            self.labelCouponFare.isHidden = false
            let val = self.service?.pricing?.estimated_fare_surge
            attrStr = NSMutableAttributedString(string: "\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(val ?? 0)", maximumDecimal: 2))")
            attrStr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSNumber(value: NSUnderlineStyle.single.rawValue), range: NSMakeRange(0, attrStr.length))
            attrStr.addAttribute(NSAttributedString.Key.strikethroughColor, value: UIColor.darkGray, range: NSMakeRange(0, attrStr.length))
            
            self.labelEstimationFare.attributedText = attrStr
            self.labelCouponFare.text = "\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(amount ?? 0)", maximumDecimal: 2))"
        } else { //
            self.labelEstimationFare.attributedText = NSMutableAttributedString(string:"\(User.main.currency ?? .Empty) \(Formatter.shared.limit(string: "\(amount ?? 0)", maximumDecimal: 2))")
            self.labelCouponFare.isHidden = true
        }
        
    }
    
    @IBAction private func buttonScheduleAction(){
        self.service?.promocode = self.selectedCoupon
        self.scheduleAction?(self.service!)
    }
    
    @IBAction private func buttonRideNowAction(){
        self.service?.promocode = self.selectedCoupon
        self.rideNowAction?(self.service!)
    }
    
    @IBAction private func useWalletAction(){
        self.isWalletChecked = !isWalletChecked
        
    }
    @IBAction private func buttonCouponAction() {
        self.onclickCoupon?( self.availablePromocodes,self.selectedCoupon, { [weak self] selectedCouponCode in  // send Available couponlist and get the selected coupon entity
            if selectedCouponCode != nil {
                var request = ApplyPromo()
                request.estimated_fare_surge = self?.service?.pricing?.estimated_fare_surge
                request.promocode_id = selectedCouponCode?.id
                self?.presenter?.post(api: .applyPromo, data: request.toData())
            } else { //set previous estimated value if promo removed.
                let value = self?.service?.pricing?.estimated_fare_surge
                self?.setEstimationFare(amount: value,isStrike: false)
            }
            self?.selectedCoupon = selectedCouponCode
            self?.isPromocodeEnabled = true
        })
    }
    @IBAction private func buttonChangePaymentAction() {
        self.paymentChangeClick?({ [weak self] selectedCard in
            self?.selectedCard = selectedCard
        })
    }
    
    @IBAction private func buttonAirportFareAction() {
        self.airportFareAction?()
    }
}

// MARK:- PostViewProtocol

extension RequestSelectionView : PostViewProtocol {
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getPromocodeList(api: Base, data: [PromocodeEntity]) {
        self.availablePromocodes = data
    }
    
    func getApplyPromo(api: Base, data: ApplyPromo?) {
        if data != nil {
            self.appliedPromo = data!
        }
        
        self.appliedPromo = data

    }
    
}


//
//  RequestSelectionView.swift
//  User
//
//  Created by CSS on 19/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RequestSelectionView: UIView {
    
   
    @IBOutlet private weak var labelUseWalletString : UILabel!
    @IBOutlet private weak var imageViewWallet : UIImageView!
    @IBOutlet private weak var buttonScheduleRide : UIButton!
    @IBOutlet private weak var buttonRideNow : UIButton!
    @IBOutlet private weak var viewUseWallet : UIView!
    @IBOutlet private weak var labelEstimationFareString : UILabel!
    @IBOutlet private weak var labelEstimationFare : UILabel!
    @IBOutlet private weak var labelCouponString : UILabel!
    @IBOutlet private weak var labelPaymentMode : Label!
    @IBOutlet private weak var buttonChangePayment : UIButton!
    @IBOutlet private weak var buttonCoupon : UIButton!
    @IBOutlet private weak var imageViewModal : UIImageView!
    
    var scheduleAction : ((Service)->())?
    var rideNowAction : ((Service)->())?
    
    var isWalletChecked = false {  // Handle Wallet
        didSet {
            self.imageViewWallet.image = isWalletChecked ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check-box-empty")
            self.service?.pricing?.useWallet = isWalletChecked.hashValue
        }
    }
    
    var paymentType : PaymentType = .NONE {
        didSet {
            let text = "\(Constants.string.payment.localize()):\(paymentType.rawValue.localize())"
            self.labelPaymentMode.text = text
            self.labelPaymentMode.attributeColor = .secondary
            self.labelPaymentMode.startLocation = ((text.count)-(paymentType.rawValue.localize().count))
            self.labelPaymentMode.length = paymentType.rawValue.localize().count
        }
    }
    
    private var service : Service?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
}

// MARK:- Methods

extension RequestSelectionView {
    
    // MARK:- Initial Loads
    
    private func initialLoads() {
        self.backgroundColor = .clear
        self.isWalletChecked = false
        self.localize()
        self.setDesign()
        self.viewUseWallet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.useWalletAction)))
        self.paymentType = .NONE
        self.buttonChangePayment.isHidden = !(User.main.isCashAllowed && User.main.isCardAllowed) // Change button enabled only if both payment modes are enabled
    }
    
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: buttonRideNow, isTitle: true)
        Common.setFont(to: buttonScheduleRide, isTitle:  true)
        Common.setFont(to: labelUseWalletString)
        Common.setFont(to: labelEstimationFareString, isTitle: true)
        Common.setFont(to: labelEstimationFare, isTitle: true)
        Common.setFont(to: labelCouponString)
        Common.setFont(to: labelPaymentMode)
        Common.setFont(to: buttonChangePayment)
        Common.setFont(to: buttonCoupon)
        
    }
    
    
    // MARK:- Localize
    
    private func localize() {
        
        self.labelUseWalletString.text = Constants.string.useWalletAmount.localize()
        self.buttonScheduleRide.setTitle(Constants.string.scheduleRide.localize().uppercased(), for: .normal)
        self.buttonRideNow.setTitle(Constants.string.rideNow.localize().uppercased(), for: .normal)
        self.labelEstimationFareString.text = Constants.string.estimatedFare.localize()
        self.labelCouponString.text = Constants.string.coupon.localize()
        
    }
    
    
    func setValues(values : Service) {
        self.service = values
        self.viewUseWallet.isHidden = !(self.service?.pricing?.wallet_balance != 0)
        self.labelEstimationFare.text = "\(User.main.currency ?? .Empty) \(self.service?.pricing?.estimated_fare ?? 0)"
        self.paymentType = User.main.isCashAllowed ? .CASH :( User.main.isCardAllowed ? .CARD : .NONE)
        
    }
    
    
    @IBAction private func buttonScheduleAction(){
        self.scheduleAction?(self.service!)
    }
    
    @IBAction private func buttonRideNowAction(){
        self.rideNowAction?(self.service!)
    }
    
    @IBAction private func useWalletAction(){
        self.isWalletChecked = !isWalletChecked
        
    }
    
    
}

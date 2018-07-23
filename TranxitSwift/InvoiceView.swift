//
//  InvoiceView.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class InvoiceView: UIView {

    @IBOutlet private weak var labelBookingString : UILabel!
    @IBOutlet private weak var labelBooking : UILabel!
    @IBOutlet private weak var labelDistanceTravelledString : UILabel!
    @IBOutlet private weak var labelDistanceTravelled : UILabel!
    @IBOutlet private weak var labelTimeTakenString : UILabel!
    @IBOutlet private weak var labelTimeTaken : UILabel!
    @IBOutlet private weak var labelBaseFareString : UILabel!
    @IBOutlet private weak var labelBaseFare : UILabel!
    @IBOutlet private weak var labelDistanceFareString : UILabel!
    @IBOutlet private weak var labelDistanceFare : UILabel!
    @IBOutlet private weak var labelDiscountString : UILabel!
    @IBOutlet private weak var labelDiscount : UILabel!
    @IBOutlet private weak var labelTotalString : UILabel!
    @IBOutlet private weak var labelTotal : UILabel!
    @IBOutlet private weak var imageViewPaymentType : UIImageView!
    @IBOutlet private weak var labelPaymentType : UILabel!
    @IBOutlet private weak var buttonPayNow : UIButton!
    @IBOutlet private weak var labelTitle : UILabel!
    
    var onClickPaynow : (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.intialLoads()
    }
    
}

// MARK:- Methods

extension InvoiceView {
    
    func intialLoads() {
        self.buttonPayNow.addTarget(self, action: #selector(self.buttonPaynowAction), for: .touchUpInside)
        self.localize()
        self.setDesign()
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelTitle, isTitle: true)
        Common.setFont(to: buttonPayNow, isTitle: true)
        Common.setFont(to: labelPaymentType, isTitle: true)
        Common.setFont(to: labelTotal, isTitle: true, size: 18)
        Common.setFont(to: labelTotalString, isTitle: true)
        Common.setFont(to: labelDiscount)
        Common.setFont(to: labelDiscountString)
        Common.setFont(to: labelBooking)
        Common.setFont(to: labelBookingString)
        Common.setFont(to: labelBaseFare)
        Common.setFont(to: labelBaseFareString)
        Common.setFont(to: labelDistanceFare)
        Common.setFont(to: labelDistanceFareString)
        Common.setFont(to: labelTimeTaken)
        Common.setFont(to: labelTimeTakenString)
        Common.setFont(to: labelDistanceTravelled)
        Common.setFont(to: labelDistanceTravelledString)
        
    }
    
    
    
    // MARK:- Localize
    
    private func localize() {
        
        self.labelBookingString.text = Constants.string.bookingId.localize()
        self.labelDistanceTravelledString.text = Constants.string.distanceTravelled.localize()
        self.labelTimeTakenString.text = Constants.string.timeTaken.localize()
        self.labelBaseFareString.text = Constants.string.baseFare.localize()
        self.labelDistanceFareString.text = Constants.string.distanceFare.localize()
        self.labelDiscountString.text = Constants.string.discount.localize()
        self.buttonPayNow.setTitle(Constants.string.paynow.localize(), for: .normal)
        self.labelTitle.text = Constants.string.invoice.localize()
    }
    
    func set(request : Request) {
        
        self.labelBooking.text = request.booking_id
        self.labelDistanceTravelled.text = "\(Float.removeNil(request.payment?.distance)) \(distanceType.localize())"
        self.labelTimeTaken.text = "\(String.removeNil(request.travel_time)) \(Constants.string.mins.localize())"
        self.labelBaseFare.text = "\(String.removeNil(User.main.currency)) \(Float.removeNil(request.payment?.fixed))"
        self.labelDistanceFare.text = "\(String.removeNil(User.main.currency)) \(Float.removeNil(request.payment?.distance))"
        self.labelDiscount.text = "\(String.removeNil(User.main.currency)) \(Float.removeNil(request.payment?.discount))"
        self.labelTotal.text = "\(String.removeNil(User.main.currency)) \(Float.removeNil(request.payment?.payable))"
        self.labelPaymentType.text = request.payment_mode?.rawValue
        self.imageViewPaymentType.image = request.payment_mode == .CASH ? #imageLiteral(resourceName: "money_icon") : #imageLiteral(resourceName: "visa")
        self.buttonPayNow.isHidden = request.payment_mode == .CASH
        
    }
    
    @IBAction private func buttonPaynowAction() {
        
        self.onClickPaynow?()
    }
    
}

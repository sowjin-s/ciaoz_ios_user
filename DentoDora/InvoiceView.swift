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
    @IBOutlet private weak var labelTaxString : UILabel!
    @IBOutlet private weak var labelTax : UILabel!
    @IBOutlet private weak var labelTotalString : UILabel!
    @IBOutlet private weak var labelTotal : UILabel!
    @IBOutlet private weak var imageViewPaymentType : UIImageView!
    @IBOutlet private weak var labelPaymentType : UILabel!
    @IBOutlet private weak var buttonPayNow : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.intialLoads()
    }
    
}

// MARK:- Methods

extension InvoiceView {
    
    func intialLoads() {
        self.localize()
    }
    
    
    // MARK:- Localize
    
    private func localize() {
        
        self.labelBookingString.text = Constants.string.bookingId.localize()
        self.labelDistanceTravelledString.text = Constants.string.distanceTravelled.localize()
        self.labelTimeTakenString.text = Constants.string.timeTaken.localize()
        self.labelBaseFareString.text = Constants.string.baseFare.localize()
        self.labelDistanceFareString.text = Constants.string.distanceFare.localize()
        self.labelTaxString.text = Constants.string.tax.localize()
        self.buttonPayNow.setTitle(Constants.string.paynow.localize(), for: .normal)
        
    }
    
}

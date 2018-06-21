//
//  RequestSelectionView.swift
//  User
//
//  Created by CSS on 19/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RequestSelectionView: UIView {
    
    @IBOutlet private weak var viewCurve : UIView!
    @IBOutlet private weak var labelSurge : UILabel!
    @IBOutlet private weak var labelSurgeDescription : UILabel!
    @IBOutlet private weak var constraintSurgeViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var labelEstimationString : UILabel!
    @IBOutlet private weak var labelETAString : UILabel!
    @IBOutlet private weak var labelModelString : UILabel!
    @IBOutlet private weak var labelEstimation : UILabel!
    @IBOutlet private weak var labelETA : UILabel!
    @IBOutlet private weak var labelModel : UILabel!
    @IBOutlet private weak var labelUseWalletString : UILabel!
    @IBOutlet private weak var imageViewWallet : UIImageView!
    @IBOutlet private weak var buttonScheduleRide : UIButton!
    @IBOutlet private weak var buttonRideNow : UIButton!
    @IBOutlet private weak var viewUseWallet : UIView!
    @IBOutlet private weak var labelDistanceString : UILabel!
    @IBOutlet private weak var labelDistance : UILabel!
    
    private var isHideSurge = false {
        didSet {
            constraintSurgeViewHeight.constant = isHideSurge ? 0 : 30
            self.labelSurgeDescription.isHidden = isHideSurge
        }
    }
    
    var scheduleAction : ((EstimateFare?)->())?
    var rideNowAction : ((EstimateFare?)->())?
    
    var isWalletChecked = false {  // Handle Wallet
        didSet {
            self.imageViewWallet.image = isWalletChecked ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check-box-empty")
            self.estimateFare?.useWallet = isWalletChecked.hashValue
        }
    }
    
    private var estimateFare : EstimateFare?
    
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
        let layer = viewCurve.createCircleShapeLayer(strokeColor: .clear, fillColor: .black)
        self.viewCurve.layer.insertSublayer(layer, below: labelSurge.layer)
        self.isHideSurge = false
        self.isWalletChecked = false
        self.localize()
        self.setDesign()
    }
    
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelSurge, isTitle: true, size: 20)
        Common.setFont(to: buttonRideNow, isTitle: true)
        Common.setFont(to: buttonScheduleRide, isTitle:  true)
        Common.setFont(to: labelUseWalletString)
        Common.setFont(to: labelSurgeDescription)
        Common.setFont(to: labelETA)
        Common.setFont(to: labelETAString)
        Common.setFont(to: labelEstimation)
        Common.setFont(to: labelModel)
        Common.setFont(to: labelDistance)
        Common.setFont(to: labelDistanceString)
        Common.setFont(to: labelModelString)
        Common.setFont(to: labelEstimationString)
    }
    
    
    // MARK:- Localize
    
    private func localize() {
        
        self.labelSurgeDescription.text = Constants.string.dueToHighDemandPriceMayVary.localize()
        self.labelEstimationString.text = Constants.string.estimatedFare.localize()
        self.labelETAString.text = Constants.string.ETA.localize()
        self.labelModelString.text = Constants.string.model.localize()
        self.labelUseWalletString.text = Constants.string.useWalletAmount.localize()
        self.buttonScheduleRide.setTitle(Constants.string.scheduleRide.localize().uppercased(), for: .normal)
        self.buttonRideNow.setTitle(Constants.string.rideNow.localize().uppercased(), for: .normal)
        self.viewUseWallet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.useWalletAction)))
        self.labelDistanceString.text = Constants.string.totalDistance.localize()
    }
    
    
    func setValues(values : EstimateFare?) {
       
        self.isHideSurge = values?.surge == false.hashValue
        self.labelSurge.text = values?.surge_value
        self.labelDistance.text = "\(values?.distance ?? 0) \(distanceType.localize())"
        self.labelEstimation.text = "\(String.removeNil(User.main.currency)) \(values?.estimated_fare ?? 0)"
        self.labelModel.text = values?.model
        self.labelETA.text = values?.time
        self.viewUseWallet.isHidden = (values?.wallet_balance == 0)
        self.estimateFare = values
    }
    
    
    @IBAction private func buttonScheduleAction(){
        self.scheduleAction?(self.estimateFare)
    }
    
    @IBAction private func buttonRideNowAction(){
        self.rideNowAction?(self.estimateFare)
    }
    
    @IBAction private func useWalletAction(){
        self.isWalletChecked = !isWalletChecked
        
    }
    
    
}
//
//  RideStatusView.swift
//  User
//
//  Created by CSS on 23/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RideStatusView: UIView {

    @IBOutlet private weak var labelTopTitle : UILabel!
    @IBOutlet private weak var imageViewProvider : UIImageView!
    @IBOutlet private weak var labelProviderName : UILabel!
    @IBOutlet private weak var viewRating : FloatRatingView!
    @IBOutlet private weak var imageViewService : UIImageView!
    @IBOutlet private weak var labelServiceName : UILabel!
    @IBOutlet private weak var labelServiceDescription : UILabel!
    @IBOutlet private weak var labelServiceNumber : UILabel!
    @IBOutlet private weak var labelPeakDescription : UILabel!
    @IBOutlet private weak var buttonCall : UIButton!
    @IBOutlet private weak var buttonCancel : UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
}

extension RideStatusView {
    
    private func initialLoads() {
        self.initRating()
        self.localize()
    }
    
    // MARK:- Localization
    private func localize() {
        self.labelTopTitle.text = Constants.string.driverAccepted.localize()
        self.labelPeakDescription.text = Constants.string.peakInfo.localize()
        self.buttonCall.setTitle(Constants.string.call.localize().uppercased()
            , for: .normal)
        self.buttonCancel.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
    }
    
    // MARK:- Rating
    private func initRating() {
        
        viewRating.fullImage = #imageLiteral(resourceName: "StarFull")
        viewRating.emptyImage = #imageLiteral(resourceName: "StarEmpty")
        viewRating.minRating = 0
        viewRating.maxRating = 5
        viewRating.rating = 0
        viewRating.editable = false
        viewRating.minImageSize = CGSize(width: 3, height: 3)
        viewRating.floatRatings = true
        viewRating.contentMode = .scaleAspectFit
    }
    
}

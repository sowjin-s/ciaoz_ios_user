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
    
    private var currentStatus : RideStatus = .none {
        didSet{
            DispatchQueue.main.async {
                if [RideStatus.started, .accepted].contains(self.currentStatus) {
                    self.buttonCancel.setTitle(Constants.string.Cancel.localize().uppercased(), for: .normal)
                } else {
                    self.buttonCancel.setTitle(Constants.string.shareRide.localize().uppercased(), for: .normal)
                }
            }
        }
    }
    
    var onClickCancel : (()->Void)?
    var onClickShare : (()->Void)?

    private var request : Request?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imageViewProvider.makeRoundedCorner()
    }
}

extension RideStatusView {
    
    private func initialLoads() {
        self.initRating()
        self.localize()
        self.buttonCall.addTarget(self, action: #selector(self.callAction), for: .touchUpInside)
    }
    
    // MARK:- Localization
    private func localize() {
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
    
    // MARK:- Set Values
    
    func set(values : Request) {
        
        self.request = values
        
        self.labelTopTitle.text = {
            switch values.status! {
                case .accepted, .started:
                   return Constants.string.driverAccepted.localize()
                case .arrived:
                   return Constants.string.driverArrived.localize()
                case .pickedup:
                   return Constants.string.youAreOnRide.localize()
                default:
                  return .Empty
               }
            }()
        
        Cache.image(forUrl: values.provider?.avatar) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageViewProvider.image = image
                }
            }
        }
        
        Cache.image(forUrl: values.service?.image) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageViewService.image = image
                }
            }
        }
        
        self.labelProviderName.text = String.removeNil(values.provider?.first_name)+" "+String.removeNil(values.provider?.last_name)
        self.viewRating.rating = Float(values.provider?.rating ?? 0)
        self.labelServiceName.text = values.service?.name
        self.labelServiceNumber.text = values.provider_service?.service_number
        self.labelServiceDescription.text = values.provider_service?.service_model
        
    }
    
    // MARK:- Call Provider
    
    @IBAction private func callAction() {
        
        if let providerNumber = request?.provider?.mobile, let url = URL(string: "tel://\(providerNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    
    // MARK:- Cancel Share Action
    
    @IBAction private func cancelShareAction() {
        
        if let status = request?.status,[RideStatus.accepted, .started].contains(status) {
            self.onClickCancel?()
        } else {
            self.onClickShare?()
        }
        
    }
    
}

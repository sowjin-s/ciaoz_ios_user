//
//  RateView.swift
//  User
//
//  Created by CSS on 14/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RateView: UIView {
    
    @IBOutlet private weak var labelTitle : UILabel!
    @IBOutlet private weak var imageView : UIImageView!
    @IBOutlet private weak var labelServiceName : UILabel!
    @IBOutlet private weak var labelBaseFareString : UILabel!
    @IBOutlet private weak var labelBaseFare : UILabel!
    @IBOutlet private weak var labelFare : UILabel!
    @IBOutlet private weak var labelFareString : UILabel!
    @IBOutlet private weak var labelFareType : UILabel!
    @IBOutlet private weak var labelFareTypeString : UILabel!
    @IBOutlet private weak var labelCapacity : UILabel!
    @IBOutlet private weak var labelCapacityString : UILabel!
    @IBOutlet private weak var buttonDone : Button!
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var onCancel : (()->Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localize()
        self.setDesign()
        self.buttonDone.addTarget(self, action: #selector(self.buttonDoneAction), for: .touchUpInside)
    }
    
    
}

extension RateView {
    
    // MARK:- Set Design
    
    private func setDesign() {
        
        Common.setFont(to: labelTitle, isTitle: true)
        Common.setFont(to: labelServiceName)
        Common.setFont(to: labelBaseFare)
        Common.setFont(to: labelBaseFareString)
        Common.setFont(to: labelFare)
        Common.setFont(to: labelFareString)
        Common.setFont(to: labelFareType)
        Common.setFont(to: labelFareTypeString)
        Common.setFont(to: labelCapacity)
        Common.setFont(to: labelCapacityString)
        Common.setFont(to: buttonDone, isTitle: true)
    }
    
    // MARK:- Localize
    
    private func localize() {
        
        self.labelTitle.text = Constants.string.rateCard.localize()
        self.labelBaseFareString.text = Constants.string.baseFare.localize()
        self.labelFareString.text = Constants.string.fare.localize()+"/"+distanceType.localize()
        self.labelFareTypeString.text = Constants.string.fareType.localize()
        self.labelCapacityString.text = Constants.string.capacity.localize()
        self.buttonDone.setTitle(Constants.string.Done.localize(), for: .normal)
        
    }
    
    // MARK:- Set Values
    
    func set(values : Service?) {
        
        Cache.image(forUrl: values?.image) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
        
        self.labelBaseFare.text = String.removeNil(User.main.currency)+"\(values?.pricing?.base_price ?? 0)"
        self.labelFare.text = String.removeNil(User.main.currency)+"\(values?.pricing?.estimated_fare ?? 0)"
        self.labelFareType.text = Constants.string.distance.localize()
        self.labelCapacity.text = "\(values?.capacity ?? 0)"
        
        
    }
    
    @IBAction private func buttonDoneAction() {
        self.onCancel?()
    }
    
}

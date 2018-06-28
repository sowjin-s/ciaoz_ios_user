//
//  ServiceSelectionCollectionViewCell.swift
//  User
//
//  Created by CSS on 11/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ServiceSelectionCollectionViewCell: UICollectionViewCell {
    
    // @IBOutlet private var imageViewHeightConstant : NSLayoutConstraint!
    // @IBOutlet private var imageViewWidthConstant : NSLayoutConstraint!
    @IBOutlet private weak var imageViewService : UIImageView!
    @IBOutlet private weak var buttonService : UIButton!
    @IBOutlet private weak var labelPricing : UILabel!
    @IBOutlet private weak var viewImageView : UIView!
    @IBOutlet private weak var labelETA : UILabel!
   // private var initialFrame = CGSize.init()
    private var service : Service?
    
    override var isSelected: Bool {
        
        didSet{
            
            self.imageViewService.layer.masksToBounds = self.isSelected
            self.transform = isSelected ? .init(scaleX: 1.2, y: 1.2) : .identity
            self.buttonService.setTitleColor(!self.isSelected ? .black : .secondary, for: .normal)
            self.viewImageView.borderLineWidth = isSelected ? 2 : 0
            self.labelETA.text = self.isSelected ? service?.pricing?.time : nil
            self.viewImageView.backgroundColor = self.isSelected ? UIColor.secondary : .clear
            self.setLabelPricing()
        }
    }
    
    func set(value : Service) {
        
        self.service = value
        buttonService.setTitle(value.name, for: .normal)
        Cache.image(forUrl: value.image) { (image) in
            DispatchQueue.main.async {
                self.imageViewService.image = image == nil ? #imageLiteral(resourceName: "sedan-car-model") : image
            }
        }
        self.setLabelPricing()

    }
    
    func setLabelPricing() {
        self.labelPricing.text =  isSelected ? {
            if let estimateFare = self.service?.pricing?.estimated_fare, let distance = self.service?.pricing?.distance {
                return "\(String.removeNil(User.main.currency))\(estimateFare)-\(distance) \(distanceType.localize())"
            }
            return nil
            }() : nil
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.viewImageView.cornerRadius = self.viewImageView.frame.width/2
    }
    
}


private extension ServiceSelectionCollectionViewCell {
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: buttonService, size : 12)
        Common.setFont(to: labelPricing, size : 10)
        Common.setFont(to: labelETA, size : 10)
    }
    
    
    private func initialLoads(){
        self.imageViewService.image = #imageLiteral(resourceName: "sedan-car-model")
        self.buttonService.setTitleColor(.black, for: .normal)
        self.viewImageView.borderColor = .secondary
        self.setDesign()
       // self.initialFrame = self.imageViewService.frame.size
    }
}

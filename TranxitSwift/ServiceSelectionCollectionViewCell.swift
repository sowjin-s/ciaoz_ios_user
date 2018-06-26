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
   // private var initialFrame = CGSize.init()
    private var service : Service?
    
    override var isSelected: Bool {
        
        didSet{
            
            
            // self.imageViewHeightConstant.constant = self.isSelected ? self.initialFrame.height/2 : 0
            //self.imageViewWidthConstant.constant = self.isSelected ? self.initialFrame.width/2 : 0
           // self.viewImageView.cornerRadius = isSelected ? (self.viewImageView.frame.width/2) : 0
            self.imageViewService.layer.masksToBounds = self.isSelected
            self.transform = isSelected ? .init(scaleX: 1.4, y: 1.4) : .identity
            self.buttonService.setTitleColor(!self.isSelected ? .black : .secondary, for: .normal)
            self.viewImageView.borderLineWidth = isSelected ? 2 : 0
//            if let image = self.service?.image {
//                Cache.image(forUrl: image) { (image) in
//                    let image = image == nil ? #imageLiteral(resourceName: "CarplaceHolder") : image!
//                        DispatchQueue.main.async {
//                            self.imageViewService.image = image.imageWithInsets(insetDimen: self.isSelected ? 30 : 0)
//                    }
//                }
//            }
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
            if let price = self.service?.pricing?.base_price, let distance = self.service?.pricing?.estimated_fare {
                return "\(String.removeNil(User.main.currency))\(price)-\(distance) \(distanceType.localize())"
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
        Common.setFont(to: labelPricing, size : 8)
    }
    
    
    private func initialLoads(){
        self.imageViewService.image = #imageLiteral(resourceName: "sedan-car-model")
        self.buttonService.setTitleColor(.black, for: .normal)
        self.viewImageView.borderColor = .secondary
        self.setDesign()
       // self.initialFrame = self.imageViewService.frame.size
    }
}

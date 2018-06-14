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
    
    //  private var initialFrame : CGSize = .zero
    
    override var isSelected: Bool {
        
        didSet{
            // self.imageViewHeightConstant.constant = self.isSelected ? self.initialFrame.height/2 : 0
            //self.imageViewWidthConstant.constant = self.isSelected ? self.initialFrame.width/2 : 0
            self.transform = isSelected ? .init(scaleX: 1.4, y: 1.4) : .identity
            self.buttonService.backgroundColor = !self.isSelected ? .clear : .secondary
            self.buttonService.setTitleColor(!self.isSelected ? .black : .white, for: .normal)
        }
    }
    
    func set(value : Service) {
        
        buttonService.setTitle(value.name, for: .normal)
        Cache.image(forUrl: value.image) { (image) in
            DispatchQueue.main.async {
                self.imageViewService.image = image == nil ? #imageLiteral(resourceName: "sedan-car-model") : image
            }
        }
        
        if let price = value.pricing?.base_price, let distance = value.pricing?.estimated_fare {
            self.labelPricing.text = "\(String.removeNil(User.main.currency)) \(price)/\(distance) \(distanceType.localize())"
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
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
        self.setDesign()
        //self.initialFrame = self.imageViewService.frame.size
    }
}

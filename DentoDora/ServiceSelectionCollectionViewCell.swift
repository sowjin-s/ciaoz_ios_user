//
//  ServiceSelectionCollectionViewCell.swift
//  User
//
//  Created by CSS on 11/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ServiceSelectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var imageViewHeightConstant : NSLayoutConstraint!
    @IBOutlet private var imageViewWeightConstant : NSLayoutConstraint!
    @IBOutlet private weak var imageViewService : UIImageView!
    @IBOutlet private weak var buttonService : UIButton!
    
   override var isSelected: Bool {
        
        didSet{
            self.imageViewHeightConstant.constant = !self.isSelected ? self.imageViewService.frame.height/2 : 0
            self.imageViewWeightConstant.constant = !self.isSelected ? self.imageViewService.frame.width/2 : 0
            self.buttonService.backgroundColor = !self.isSelected ? .clear : .secondary
            self.buttonService.setTitleColor(!self.isSelected ? .black : .white, for: .normal)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func draw(_ rect: CGRect) {
        self.draw(rect)
        self.buttonService.makeRoundedCorner()
    }
    
}


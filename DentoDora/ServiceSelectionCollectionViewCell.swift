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
    
  //  private var initialFrame : CGSize = .zero
    
   override var isSelected: Bool {
        
        didSet{
           // self.imageViewHeightConstant.constant = self.isSelected ? self.initialFrame.height/2 : 0
            //self.imageViewWidthConstant.constant = self.isSelected ? self.initialFrame.width/2 : 0
            self.transform = isSelected ? .init(scaleX: 1.2, y: 1.2) : .identity
            self.buttonService.backgroundColor = !self.isSelected ? .clear : .secondary
            self.buttonService.setTitleColor(!self.isSelected ? .black : .white, for: .normal)
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
    
    private func initialLoads(){
        self.imageViewService.image = #imageLiteral(resourceName: "walkthrough1")
        //self.initialFrame = self.imageViewService.frame.size
    }
}

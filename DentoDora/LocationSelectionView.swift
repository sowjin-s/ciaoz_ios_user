//
//  LocationSelectionView.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class LocationSelectionView: UIView {

    @IBOutlet private weak var viewTop : UIView!
    @IBOutlet private weak var viewBottom : UIView!
    @IBOutlet private weak var viewBack : UIView!
    
    private var completion : ((LocationDetail)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
}


extension LocationSelectionView {
    
    
    private func initialLoads(){
        
    /*    self.viewTop.alpha = 0
        self.viewBottom.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.viewTop.alpha = 1
        }) { (_) in
            self.viewBottom.isHidden = false
            self.viewBottom.show(with: .bottom, duration: 0.7, completion: nil)
        }  */
        
        self.viewBottom.isHidden = true
        self.viewTop.show(with: .top) {
            self.viewBottom.isHidden = false
            self.viewBottom.show(with: .bottom, duration: 0.3, completion: nil)
        }
        
    }
    
    
    func backButton(_ completion :@escaping ((LocationDetail)->Void)){
        
        self.viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backButtonAction)))
        self.completion = completion
    }
    
    
    @IBAction private func backButtonAction(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.viewBottom.frame.origin.y = self.viewBottom.frame.height
            self.viewTop.frame.origin.y = -self.viewTop.frame.height
        }) { (_) in
            self.isHidden = true
            self.removeFromSuperview()
        }
        
    }
    
}

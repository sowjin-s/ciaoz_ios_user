//
//  termscondition.swift
//  TranxitUser
//
//  Created by Ranjith on 15/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class termscondition: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var webpage: UIWebView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showAnimate()
        self.initialLoads()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.showAnimate()
        self.initialLoads()
    }
}


extension termscondition {
    
    private func initialLoads() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapBlurButton(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapBlurButton(_ sender: UITapGestureRecognizer) {
        //print("Please Help!")
        self.removeAnimate()
    }
    
    private func showAnimate(){
        
        self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 1.0
            self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    private func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
                self.removeFromSuperview()
            }
        });
    }
}

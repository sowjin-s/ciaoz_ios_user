//
//  CouponViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController {

    @IBOutlet private weak var labelMessage : UILabel!
    @IBOutlet private var textFieldCouponCode : TextField!
    @IBOutlet private weak var labelAddCouponString : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK:- Methods

extension CouponViewController {
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.coupon.localize()
        self.localize()
    }
    
    
    
    private func localize() {
        self.textFieldCouponCode.placeholder = Constants.string.enterCouponCode.localize()
        self.labelAddCouponString.text = Constants.string.addCouponCode.localize()
    }
    
}

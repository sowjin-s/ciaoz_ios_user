//
//  WalletViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var labelBalance : Label!
    @IBOutlet private weak var textFieldAmount : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}


extension WalletViewController {
    
    private func initalLoads() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.wallet.localize()
    }
    
    @IBAction private func buttonAmountAction(sender : UIButton) {
        
        textFieldAmount.text = sender.title(for: .normal)
        
    }
    
    
    @IBAction private func buttonAddAmountClick() {
        
        print("Clicked")
    }
    
}

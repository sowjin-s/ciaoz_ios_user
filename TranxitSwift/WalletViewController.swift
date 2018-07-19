//
//  WalletViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var labelBalance : Label!
    @IBOutlet private weak var textFieldAmount : UITextField!
    @IBOutlet private weak var viewWallet : UIView!
    
    @IBOutlet private weak var buttonAddAmount : UIButton!
    @IBOutlet var labelWallet: UILabel!
    @IBOutlet var labelAddMoney: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        KeyboardAvoiding.avoidingView = self.viewWallet
      //  IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // IQKeyboardManager.sharedManager().enable = false
    }
    
}


extension WalletViewController {
    
    private func initalLoads() {
        
        self.view.dismissKeyBoardonTap()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.wallet.localize()
        self.setDesign()
        self.labelBalance.text = String.removeNil(User.main.currency)+" "+"\(User.main.wallet_balance ?? 0)"
        self.textFieldAmount.delegate = self
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelBalance)
        Common.setFont(to: textFieldAmount)
        
        
        labelAddMoney.text = Constants.string.addAmount.localize()
        labelWallet.text = Constants.string.yourWalletAmnt.localize()
        buttonAddAmount.setTitle(Constants.string.ADDAMT, for: .normal)
        
    }
    
    @IBAction private func buttonAmountAction(sender : UIButton) {
        
        textFieldAmount.text = sender.title(for: .normal)
        
    }
    
    
    @IBAction private func buttonAddAmountClick() {
        
        print("Clicked")
    }
    
}


extension WalletViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     //   print(IQKeyboardManager.sharedManager().keyboardDistanceFromTextField)
    }
}

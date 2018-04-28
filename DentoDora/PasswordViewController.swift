//
//  PasswordViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController {
    
    @IBOutlet private var viewNext : UIView!
    @IBOutlet private var textFieldPassword : HoshiTextField!
    @IBOutlet private var buttonForgotPassword : UIButton!
    @IBOutlet private var buttonCreateAccount : UIButton!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!

    private var email : String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialLoads()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size
    }

}


//MARK:- Methods

extension PasswordViewController {

    private func initialLoads(){
        
        self.setDesigns()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.scrollView.addSubview(viewScroll)
        self.buttonCreateAccount.addTarget(self, action: #selector(self.createAccountAction), for: .touchUpInside)
        self.buttonForgotPassword.addTarget(self, action: #selector(self.forgotPasswordAction), for: .touchUpInside)
        self.textFieldPassword.setPasswordView()
        
    }
    
    private func setDesigns(){
        
        self.textFieldPassword.borderActiveColor = .primary
        self.textFieldPassword.borderInactiveColor = .lightGray
        self.textFieldPassword.placeholderColor = .gray
        self.textFieldPassword.textColor = .black
        self.textFieldPassword.delegate = self
        self.textFieldPassword.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 2)
        
    }
    
    private func localize(){
        
        self.textFieldPassword.placeholder = Constants.string.enterPassword.localize()
        self.buttonCreateAccount.setAttributedTitle(NSAttributedString(string: Constants.string.iNeedTocreateAnAccount.localize(), attributes: [.font : UIFont(name: FontCustom.clanPro_NarrMedium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)]), for: .normal)
        self.buttonForgotPassword.setAttributedTitle(NSAttributedString(string: Constants.string.iForgotPassword.localize(), attributes: [.font : UIFont(name: FontCustom.clanPro_NarrMedium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14)]), for: .normal)
        self.navigationItem.title = Constants.string.welcomeBackPassword.localize()
    }
    
    
    //MARK:- Set Values
    
    func set(email : String?){
        
        self.email = email
        
    }
    
    
    //MARK:- Next View Tap Action
    
    @IBAction private func nextAction(){
        
        self.viewNext.addPressAnimation()
        
        if email == nil { //Go back if Email is nil
            
            self.popOrDismiss(animation: true)
        }
        
        guard  let passwordText = self.textFieldPassword.text, !passwordText.isEmpty else {
            
            self.view.make(toast: ErrorMessage.list.enterPassword) {
                self.textFieldPassword.becomeFirstResponder()
            }
            
            return
        }
        
    }
    
    //MARK:- Create Account

    @IBAction private func createAccountAction(){
        
        
        
    }
    
    //MARK:- Forgot Password

    
    @IBAction private func forgotPasswordAction(){
        
        
        
    }

}


extension PasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldPassword.placeholder = Constants.string.password.localize()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textFieldPassword.placeholder = Constants.string.enterPassword.localize()
        }
    }
    
}

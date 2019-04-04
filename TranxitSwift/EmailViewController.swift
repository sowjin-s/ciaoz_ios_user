//
//  EmailViewController.swift
//  User
//
//  Created by CSS on 28/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit

class EmailViewController: UIViewController {
    
    @IBOutlet private var viewNext: UIView!
    @IBOutlet private var textFieldEmail : HoshiTextField!
    @IBOutlet private var buttonCreateAcount : UIButton!
    @IBOutlet private var scrollView : UIScrollView!
    @IBOutlet private var viewScroll : UIView!
    
   
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    private var mobile: String?
    private var countryCode: String?
     var isHideLeftBarButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewNext.makeRoundedCorner()
        self.viewScroll.frame = self.scrollView.bounds
        self.scrollView.contentSize = self.viewScroll.bounds.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
       // self.textFieldEmail.becomeFirstResponder()
    }

}

//MARK:- Methods

extension EmailViewController {

    
    private func initialLoads(){
       
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        self.navigationController?.navigationBar.isHidden = false
        self.setDesigns()
        self.localize()
        self.view.dismissKeyBoardonTap()
        self.viewNext.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.nextAction)))
        if !isHideLeftBarButton {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        }
        self.scrollView.addSubview(viewScroll)
        self.buttonCreateAcount.addTarget(self, action: #selector(self.createAccountAction), for: .touchUpInside)
        self.scrollView.contentOffset = .zero
    }
    
    
    private func setDesigns(){
        
        self.textFieldEmail.borderActiveColor = .primary
        self.textFieldEmail.borderInactiveColor = .lightGray
        self.textFieldEmail.placeholderColor = .gray
        self.textFieldEmail.textColor = .black
        self.textFieldEmail.delegate = self
        Common.setFont(to: textFieldEmail)
        Common.setFont(to: buttonCreateAcount)
        
    }
    
    
    private func localize() {
        
        self.textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        let attr :[NSAttributedString.Key : Any]  = [.font : UIFont.systemFont(ofSize: 14)]
        self.buttonCreateAcount.setAttributedTitle(NSAttributedString(string: Constants.string.iNeedTocreateAnAccount.localize(), attributes: attr), for: .normal)
        self.navigationItem.title = Constants.string.whatsYourEmailAddress.localize()
        
    }
    
    
    //MARK:- Next View Tap Action
    
    @IBAction private func nextAction(){
        
       self.viewNext.addPressAnimation()
       
       guard  let emailText = self.textFieldEmail.text, !emailText.isEmpty else {
            
            self.view.make(toast: ErrorMessage.list.enterEmail) {
                self.textFieldEmail.becomeFirstResponder()
            }
            
            return
        }
        
        
        guard Common.isValid(email: emailText) else {
            self.view.make(toast: ErrorMessage.list.enterValidEmail) {
                self.textFieldEmail.becomeFirstResponder()
            }
            
            return

        }
        
        if let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.PasswordViewController) as? PasswordViewController {
            
            passwordVC.set(email: emailText)
            self.navigationController?.pushViewController(passwordVC, animated: true)
            
        }
        
        
        
    }
    
    //MARK:- Create Account
    
    @IBAction private func createAccountAction(){
        
        self.showAccountKit { (ph,code) in
            self.mobile = ph
            self.countryCode = code
            let verify = Request()
            verify.mobile = ph
            verify.type = "user"
            self.presenter?.post(api: .verifyMobile, data: verify.toData())
        }
    }
}

extension EmailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        textFieldEmail.placeholder = Constants.string.email.localize()
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            textFieldEmail.placeholder = Constants.string.emailPlaceHolder.localize()
        }
    }
    
}

extension EmailViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
    }
    
    func getVerifiedMobile(api: Base, data: successLog?) {
        self.loader.isHidden = true
        if data?.status != 0 {
            DispatchQueue.main.async {
                self.view.make(toast: "Mobile number Already Exists")
            }
        } else {
            self.view.make(toast: "Mobile number Verified")
            let signup = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.SignUpTableViewController) as? SignUpUserTableViewController
            signup?.mobile = mobile
            signup?.code = countryCode
            self.navigationController?.pushViewController(signup!, animated: true)
        }
    }
    
}

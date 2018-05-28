//
//  SignUpUserTableViewController.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit

class SignUpUserTableViewController: UITableViewController {
    
    @IBOutlet var firstNameText: HoshiTextField!
    @IBOutlet var emailtext: HoshiTextField!
    @IBOutlet var lastNameText: HoshiTextField!
    
    @IBOutlet var passwordText: HoshiTextField!
    
    @IBOutlet var confirmPwdText: HoshiTextField!
    
    //@IBOutlet var countryText: HoshiTextField!
    
   // @IBOutlet var timeZone: HoshiTextField!
    
   // @IBOutlet var referralCodeText: HoshiTextField!
    
   // @IBOutlet var businessLabel: UILabel!
   // @IBOutlet var outStationLabel: UILabel!
   // @IBOutlet var personalLabel: UILabel!
   // @IBOutlet var businessimage: UIImageView!
    
    @IBOutlet var phoneNumber: HoshiTextField!
   // @IBOutlet var personalimage: UIImageView!
    
    @IBOutlet var nextView: UIView!
    
    @IBOutlet var nextImage: UIImageView!
    
   // @IBOutlet var BusinessView: UIView!
    // @IBOutlet var personalView: UIView!
    
    
  /*  private var tripType : TripType =  .Business {
        
        didSet {
            
            self.businessimage.image = tripType == .Business ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            self.personalimage.image = tripType == .Personal ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            
        }
    } */
    
    
    private var userInfo : UserData?
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    
    var presenter : PostPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationcontroller()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
       self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.nextView.makeRoundedCorner()
    }
    
}


extension SignUpUserTableViewController {
    

    private func localize(){
        self.firstNameText.placeholder = Constants.string.first.localize()
        self.lastNameText.placeholder = Constants.string.last.localize()
        self.emailtext.placeholder = Constants.string.emailPlaceHolder.localize()
        self.passwordText.placeholder = Constants.string.password
        self.confirmPwdText.placeholder = Constants.string.ConfirmPassword.localize()
//        self.countryText.placeholder = Constants.string.country.localize()
//        self.timeZone.placeholder = Constants.string.timeZone.localize()
//        self.referralCodeText.placeholder = Constants.string.referalCode.localize()
//        self.businessLabel.text = Constants.string.business.localize()
//        self.personalLabel.text = Constants.string.personal.localize()
        
    }
    
    func setNavigationcontroller(){
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        }
        
        title = Constants.string.registerDetails.localize()
        // self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(self.backButtonClick))
        addGustureforNextBtn()
        self.view.dismissKeyBoardonTap()
        self.firstNameText.delegate = self
        self.lastNameText.delegate = self
        self.emailtext.delegate = self
        self.passwordText.delegate = self
        self.confirmPwdText.delegate = self
        self.phoneNumber.delegate = self
        
    }
    
    
    
    
    private func addGustureforNextBtn(){
        
        let nextBtnGusture = UITapGestureRecognizer(target: self, action: #selector(nextBtnTapped(sender:)))
        
        self.nextView.addGestureRecognizer(nextBtnGusture)
    }
    
    
//    private func addGustureForRadioBtn(){
//        let BusinessradioGusture = UITapGestureRecognizer(target: self, action: #selector(RatioButtonTapped(sender:)))
//        self.personalView.addGestureRecognizer(BusinessradioGusture)
//    }
//
//    @IBAction func RatioButtonTapped (sender: UITapGestureRecognizer){
//        
//        guard let currentView = sender.view else {
//            return
//        }
//        
//        self.tripType = currentView == BusinessView ? .Business : .Personal
//        
//    }
    
    
    @IBAction func nextBtnTapped(sender : UITapGestureRecognizer){
        
        sender.view?.addPressAnimation()
        self.view.endEditingForce()
        guard let email = emailtext.text, !email.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterEmail.localize())
            return
        }
        guard Common.isValid(email: email) else {
            self.showToast(string: ErrorMessage.list.enterValidEmail.localize())
            return
        }
        guard let firstName = self.firstNameText.text, !firstName.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterFirstName.localize())
            return
        }
        guard let lastName = lastNameText.text, !lastName.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterLastName.localize())
            return
        }
       
        guard let phoneNumber = phoneNumber.text, !phoneNumber.isEmpty, let mobile = Int(phoneNumber)  else {
            self.showToast(string: ErrorMessage.list.enterMobileNumber.localize())
            return
        }
        guard let password = passwordText.text, !password.isEmpty else {
             self.showToast(string: ErrorMessage.list.enterPassword.localize())
            return
        }
        guard let confirmPwd = confirmPwdText.text, !confirmPwd.isEmpty else {
             self.showToast(string: ErrorMessage.list.enterConfirmPassword.localize())
            return
        }
        guard confirmPwd == password else {
            self.showToast(string: ErrorMessage.list.passwordDonotMatch.localize())
            return
        }
        userInfo =  MakeJson.signUp(loginBy: .manual, email: email, password: password, socialId: nil, firstName: firstName, lastName: lastName, mobile: mobile)
       /* guard let country = countryText.text, country.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterCountry)
            return
        }
        guard let timeZone = timeZone.text, timeZone.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterTimezone)
            return
        }
        guard let referralCode = referralCodeText.text, referralCode.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterReferralCode)
            return
        } */
        
        //self.presenter?.post(api: .signUp, data: MakeJson. )
       // self.present(id: Storyboard.Ids.DrawerController, animation: true)

       let accountKit = AKFAccountKit(responseType: .accessToken)
       let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: phoneNumber)
       let accountKitVC = accountKit.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
       accountKitVC.enableSendToFacebook = true
       self.present(accountKitVC, animated: true, completion: nil)
      
        
    }
    

    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        
        viewcontroller.delegate = self
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .secondary
        
    }
    
    
    
    //MARK:- Show Custom Toast
    private func showToast(string : String?) {
        
         self.view.makeToast(string, point: CGPoint(x: UIScreen.main.bounds.width/2 , y: UIScreen.main.bounds.height/2), title: nil, image: nil, completion: nil)
        
    }
    
    
}


extension SignUpUserTableViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
    
        DispatchQueue.main.async {
            self.showToast(string: message)
        }
        
    }
    
    func getProfile(api: Base, data: Profile?) {
        
        if api == .signUp, data != nil {
            
            User.main.id = data?.id
            User.main.firstName = data?.first_name
            User.main.lastName = data?.last_name
            User.main.email = data?.email
            User.main.mobile = data?.mobile
            self.presenter?.post(api: .login, data: MakeJson.login(withUser: userInfo?.email,password:userInfo?.password))
            return
            
        } else if api == .login, data?.access_token != nil {
            
            User.main.accessToken = data?.access_token
            storeInUserDefaults()
        }
        
        loader.isHideInMainThread(true)
        
    }
    
}

//MARK:- AKFViewControllerDelegate

extension SignUpUserTableViewController : AKFViewControllerDelegate {
    
    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        
        viewController.dismiss(animated: true) {
              self.loader.isHidden = false
              self.presenter?.post(api: .signUp, data: self.userInfo?.toData())
        }
    }
    
}

// MARK:- UITextFieldDelegate

extension SignUpUserTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//       // let count = range.length-range.location
//        
//        if textField == passwordText {
//            let isEditable = Int.removeNil(passwordText.text?.count)<passwordLengthMax
//            passwordText.borderActiveColor = isEditable ? .primary : .red
//            passwordText.borderInactiveColor = isEditable ? .lightGray : .red
//          return isEditable
//        }
//        return true
//    }
    
//    private func textField(textField : HoshiTextField, count : Int) {
//
//        if textField == passwordText {
//            let isEditable = Int.removeNil(passwordText.text?.count)<passwordLengthMax
//            passwordText.borderActiveColor = isEditable ? .primary : .red
//            passwordText.borderInactiveColor = isEditable ? .lightGray : .red
//            return isEditable
//        }
//
//    }
    
}

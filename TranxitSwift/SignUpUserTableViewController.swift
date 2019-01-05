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
    
    @IBOutlet var countryText: HoshiTextField!
    @IBOutlet var textFieldReferCode: HoshiTextField!
    @IBOutlet var viewReferCode: UIView!
    
    @IBOutlet weak var countryImageView: UIImageView!
    
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
    private var accountKit : AKFAccountKit?
    private var countryCode : String?
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    var isReferalEnable = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationcontroller()        
        self.setDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
        self.navigationController?.isNavigationBarHidden = false
        self.presenter?.get(api: .settings, parameters: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.changeNextButtonFrame()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.nextView.isHidden = false
        self.changeNextButtonFrame()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.nextView.isHidden = true
        super.viewWillDisappear(animated)
    }
    
}


extension SignUpUserTableViewController {
    
    
    // MARK:- Designs
    
    private func setDesign() {
        
        Common.setFont(to: firstNameText)
        Common.setFont(to: emailtext)
        Common.setFont(to: lastNameText)
        Common.setFont(to: passwordText)
        Common.setFont(to: confirmPwdText)
        Common.setFont(to: phoneNumber)
        if selectedLanguage == .arabic {
            self.countryText.textAlignment = .left
        }else{
            self.countryText.textAlignment = .right
        }
        
    }
    
    
    private func localize(){
        
        self.firstNameText.placeholder = Constants.string.first.localize()
        self.lastNameText.placeholder = Constants.string.last.localize()
        self.emailtext.placeholder = Constants.string.emailPlaceHolder.localize()
        self.passwordText.placeholder = Constants.string.password
        self.confirmPwdText.placeholder = Constants.string.ConfirmPassword.localize()
        self.phoneNumber.placeholder = Constants.string.phoneNumber.localize()
        self.passwordText.placeholder = Constants.string.password.localize()
        self.countryText.placeholder = Constants.string.country.localize()
        self.textFieldReferCode.placeholder = Constants.string.referalCode.localize()
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
        self.countryText.delegate = self
        self.navigationController?.view.addSubview(nextView)
        
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            print(countryCode)
            let country = Common.getCountries()
            for eachCountry in country {
                if countryCode == eachCountry.code {
                    print(eachCountry.dial_code)
                    countryText.text = eachCountry.dial_code
                    let myImage = UIImage(named: "CountryPicker.bundle/\(eachCountry.code).png")
                    countryImageView.image = myImage
                }
            }
        }
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
        
        //sender.view?.addPressAnimation()
        self.view.endEditingForce()
        guard let email = self.validateEmail() else { return }
        
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
        guard let password = passwordText.text, !password.isEmpty, password.count>=6 else {
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
        userInfo =  MakeJson.signUp(loginBy: .manual, email: email, password: password, socialId: nil, firstName: firstName, lastName: lastName, mobile: mobile, referral_code: isReferalEnable == 0 ? "" : self.textFieldReferCode.text!)
//        guard let country = countryText.text, country.isEmpty else {
//            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterCountry)
//            return
//        }
       /* guard let timeZone = timeZone.text, timeZone.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterTimezone)
            return
        }
        guard let referralCode = referralCodeText.text, referralCode.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterReferralCode)
            return
        } */
        
        //self.presenter?.post(api: .signUp, data: MakeJson. )
       // self.present(id: Storyboard.Ids.DrawerController, animation: true)

       self.accountKit = AKFAccountKit(responseType: .accessToken)
        let akPhone = AKFPhoneNumber(countryCode: countryCode ?? "", phoneNumber: phoneNumber)
       let accountKitVC = accountKit?.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
       accountKitVC!.enableSendToFacebook = true
       self.prepareLogin(viewcontroller: accountKitVC!)
       self.present(accountKitVC!, animated: true, completion: nil)
      
        
    }
    
    private func validateEmail()->String? {
        guard let email = emailtext.text?.trimmingCharacters(in: .whitespaces), !email.isEmpty else {
            self.showToast(string: ErrorMessage.list.enterEmail.localize())
            emailtext.becomeFirstResponder()
            return nil
        }
        guard Common.isValid(email: email) else {
            self.showToast(string: ErrorMessage.list.enterValidEmail.localize())
            emailtext.becomeFirstResponder()
            return nil
        }
        return email
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
    
    
    private func changeNextButtonFrame() {

        let frameWidth : CGFloat = 50 * (UIScreen.main.bounds.width/375)
        self.nextView.makeRoundedCorner()
        self.nextView.frame = CGRect(x: UIScreen.main.bounds.width-(frameWidth+16), y: UIScreen.main.bounds.height-(frameWidth+16), width: frameWidth, height: frameWidth)
        self.nextImage.frame = CGRect(x: self.nextView.frame.width/4, y: self.nextView.frame.height/4, width: self.nextView.frame.width/2, height: self.nextView.frame.height/2)
       // self.nextImage.frame = CGRect(x: nextView.frame.midX, y: nextView.frame.midY, width: self.nextView.frame.width/2, height: self.nextView.frame.height/2)

    }
    
    
    
}


extension SignUpUserTableViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
    
        if api == .userVerify {
            self.emailtext.shake()
            vibrate(with: .weak)
            DispatchQueue.main.async {
                self.emailtext.becomeFirstResponder()
            }
        }
        if api == .phoneNubVerify {
            self.phoneNumber.shake()
            vibrate(with: .weak)
            DispatchQueue.main.async {
                self.phoneNumber.becomeFirstResponder()
            }
        }
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.showToast(string: message)
        }
        
    }
    
    func getProfile(api: Base, data: Profile?) {
        
        loader.isHideInMainThread(true)
        
        if api == .signUp, data != nil, data?.access_token != nil {
            User.main.accessToken = data?.access_token
            Common.storeUserData(from: data)
            storeInUserDefaults()
            self.navigationController?.present(Common.setDrawerController(), animated: true, completion: nil)
            //self.presenter?.get(api: .getProfile, parameters: nil)
            //self.presenter?.post(api: .login, data: MakeJson.login(withUser: userInfo?.email,password:userInfo?.password))
            return
            
        }
        /*else if api == .getProfile {
            Common.storeUserData(from: data)
            storeInUserDefaults()
            self.navigationController?.present(id: Storyboard.Ids.DrawerController, animation: true)
        } else {
            loader.isHideInMainThread(true)
        } */
    }
    
    func getSettings(api: Base, data: SettingsEntity) {
        self.viewReferCode.isHidden = data.referral?.referral == "0"
        self.isReferalEnable = Int((data.referral?.referral)!)!
    }
    
   /* func getOath(api: Base, data: LoginRequest?) {
     
        loader.isHideInMainThread(true)
        if api == .login, let accessToken = data?.access_token {
            
            User.main.accessToken = accessToken
            storeInUserDefaults()
            self.presenter?.get(api: .getProfile, parameters: nil)
            //let drawer = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
//            let window = UIWindow(frame: UIScreen.main.bounds)
//            UIApplication.shared.windows.last?.rootViewController?.popOrDismiss(animation: true)
//            let navigationController = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.DrawerController)
//            window.rootViewController = navigationController
//            window.makeKeyAndVisible()
            
        }
        
    } */
    
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
        func dismiss() {
            viewController.dismiss(animated: true) { }
            self.loader.isHidden = false
            self.presenter?.post(api: .signUp, data: self.userInfo?.toData())
        }
        if accountKit != nil {
            accountKit!.requestAccount({ (account, error) in
                if let phoneNumber = account?.phoneNumber {
                    var mobileString = phoneNumber.stringRepresentation()
                    if mobileString.hasPrefix("+") {
                        mobileString.removeFirst()
                        if let mobileInt = Int(mobileString) {
                            self.userInfo?.mobile = mobileInt
                        }
                    }
                }
                dismiss()
                return
                //print("--->>",account?.phoneNumber.)
               // print("--->>>",error)
            })
        }else {
            dismiss()
        }
        
    }
    
}

// MARK:- UITextFieldDelegate

extension SignUpUserTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == countryText {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CountryListController") as! CountryListController
            self.present(vc, animated: true, completion: nil)
            vc.searchCountryCode = { code in
                print(code)
                self.countryCode = code
                let country = Common.getCountries()
                for eachCountry in country {
                    if code == eachCountry.code {
                        print(eachCountry.dial_code)
                        self.countryText.text = eachCountry.dial_code
                        let myImage = UIImage(named: "CountryPicker.bundle/\(eachCountry.code).png")
                        self.countryImageView.image = myImage
                    }
                }
                
            }
            
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as? HoshiTextField)?.borderActiveColor = .primary
        if textField == emailtext {
        textField.placeholder = Constants.string.email.localize() }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        (textField as? HoshiTextField)?.borderActiveColor = .lightGray
        if textField == emailtext {
            if textField.text?.count == 0 {
                textField.placeholder = Constants.string.emailPlaceHolder.localize()
            } else if let email = validateEmail(){
                textField.resignFirstResponder()
                let user = User()
                user.email = email
                presenter?.post(api: .userVerify, data: user.toData())
            }
        }
        
        if textField == phoneNumber {
            if phoneNumber.text != "" {
                let user = User()
                
                let nub = "\(countryText.text!)\(phoneNumber.text!)"
                user.mobile = nub
                //user.id  = User.main.id
                presenter?.post(api: .phoneNubVerify, data: user.toData())
            }
        }
        
        if textField == lastNameText {
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                print(countryCode)
                let country = Common.getCountries()
                for eachCountry in country {
                    if countryCode == eachCountry.code {
                        print(eachCountry.dial_code)
                        countryText.text = eachCountry.dial_code
                    }
                }
            }
        }
        
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


//extension SignUpUserTableViewController {
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//    }
//
//}



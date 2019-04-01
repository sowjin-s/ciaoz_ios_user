//
//  SignUpUserTableViewController.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit
import CountryList

class SignUpUserTableViewController: UITableViewController {
    
    @IBOutlet var firstNameText: HoshiTextField!
    @IBOutlet var emailtext: HoshiTextField!
    @IBOutlet var lastNameText: HoshiTextField!
    @IBOutlet var passwordText: HoshiTextField!
    @IBOutlet var confirmPwdText: HoshiTextField!
    @IBOutlet var countryText: HoshiTextField!
    @IBOutlet var timeZone: HoshiTextField!
    @IBOutlet var referralCodeText: HoshiTextField!

    @IBOutlet private weak var termsbtn: UIButton!
    @IBOutlet private weak var checkboxbtn: UIButton!
    @IBOutlet private weak var countrycode: UIButton!

    @IBOutlet private weak var genderTitleLbl: Label!
    @IBOutlet private weak var femaleLbl: UILabel!
    @IBOutlet private weak var maleLbl: UILabel!
    @IBOutlet private weak var maleView: UIView!
    @IBOutlet private weak var femaleView: UIView!
    @IBOutlet private weak var imagefemale: UIImageView!
    @IBOutlet private weak var imagemale: UIImageView!
    @IBOutlet private weak var imageProfile: UIImageView!
    @IBOutlet private weak var viewProfile: UIView!



    // @IBOutlet var referralCodeText: HoshiTextField!
    
   // @IBOutlet var businessLabel: UILabel!
   // @IBOutlet var outStationLabel: UILabel!
   // @IBOutlet var personalLabel: UILabel!
   // @IBOutlet var businessimage: UIImageView!
    
    @IBOutlet var phoneNumber: HoshiTextField!
   // @IBOutlet var personalimage: UIImageView!
    
    @IBOutlet var nextView: UIView!
    
    @IBOutlet var nextImage: UIImageView!
    
    
    var TermsConditionsView : termscondition?
    var rideNow : RideNowView?
    private var countryList = CountryList()

    
   // @IBOutlet var BusinessView: UIView!
    // @IBOutlet var personalView: UIView!
    
    
  /*  private var tripType : TripType =  .Business {
        
        didSet {
            
            self.businessimage.image = tripType == .Business ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            self.personalimage.image = tripType == .Personal ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            
        }
    } */
    
    var mobile: String?
    var code: String?
    private var changedImage : UIImage?
    //private var userInfo : Signup?
    private var emergency_country_code: String? = ""
    private var accountKit : AKFAccountKit?
    
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                let image = #imageLiteral(resourceName: "check").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                checkboxbtn.setImage(image, for: UIControl.State.normal)
                checkboxbtn.tintColor = UIColor.black
            } else {
                let image = #imageLiteral(resourceName: "check-box-empty").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                checkboxbtn.setImage(image, for: UIControl.State.normal)
                checkboxbtn.tintColor = UIColor.black
            }
        }
    }
    
    var isGenderSelected: Bool = false {
        didSet{
            if isGenderSelected == true {
                imagefemale.image = #imageLiteral(resourceName: "radioselected").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imagemale.image = #imageLiteral(resourceName: "uncheck_icon").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            } else {
                imagemale.image = #imageLiteral(resourceName: "radioselected").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                imagefemale.image = #imageLiteral(resourceName: "uncheck_icon").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationcontroller()
        self.setDesign()
        self.initialloads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        localize()
        self.navigationController?.isNavigationBarHidden = false
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


extension SignUpUserTableViewController: UIWebViewDelegate {
    
    
    // MARK:- Designs
    
    private func setDesign() {
        
        Common.setFont(to: firstNameText)
        Common.setFont(to: emailtext)
        Common.setFont(to: lastNameText)
        Common.setFont(to: passwordText)
        Common.setFont(to: confirmPwdText)
        Common.setFont(to: phoneNumber)
        Common.setFont(to: timeZone)
        Common.setFont(to: countryText)
        Common.setFont(to: termsbtn)
        Common.setFont(to: referralCodeText)
        Common.setFont(to: countrycode)
        Common.setFont(to: genderTitleLbl, isTitle: false, size:13.0)
        Common.setFont(to: maleLbl)
        Common.setFont(to: femaleLbl)

        termsbtn.tintColor = UIColor.black
        //let image = #imageLiteral(resourceName: "check-box-empty").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        //checkboxbtn.setImage(image, for: .normal)
        checkboxbtn.tintColor = UIColor.black
        countrycode.tintColor = UIColor.black
    }
    
    private func initialloads(){
        let val = UserDefaults.standard.value(forKey: "referralToken") as? String
        self.referralCodeText.text = val
        self.phoneNumber.text = mobile
        self.checkboxbtn.addTarget(self, action: #selector(self.checkboxAction), for: .touchUpInside)
        self.termsbtn.addTarget(self, action: #selector(self.termsAction), for: .touchUpInside)
        self.countrycode.addTarget(self, action: #selector(self.ChangeCountryCode), for: .touchUpInside)
        self.isChecked = false
        self.isGenderSelected = false
        self.countryList.delegate = self
        if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
            countrycode.setTitle("+" + getCountryCallingCode(countryRegionCode: countryCode), for: .normal)
            emergency_country_code = "+" + getCountryCallingCode(countryRegionCode: countryCode)
        }
        
        let gendermale = UITapGestureRecognizer(target: self, action: #selector(self.gender(_:)))
        self.maleView.addGestureRecognizer(gendermale)
        let genderfemale = UITapGestureRecognizer(target: self, action: #selector(self.gender(_:)))
        self.femaleView.addGestureRecognizer(genderfemale)
        self.viewProfile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.changeImage)))
    }
    
    @IBAction private func termsAction() {
      
        self.TermsConditionsView = Bundle.main.loadNibNamed(XIB.Names.TermsConditions, owner: self, options: [:])?.first as? termscondition
        print(TermsConditionsView?.frame.height as Any)
        self.TermsConditionsView?.frame = CGRect(x: 0, y: 0, width: (self.view.frame.width), height: (self.view.frame.height - 140))
        self.TermsConditionsView?.clipsToBounds = false
        self.view.addSubview(TermsConditionsView!)
        self.TermsConditionsView?.webpage.loadRequest(NSURLRequest(url: NSURL(string: "http://app.ciaoz2u.com/privacy")! as URL) as URLRequest)
    }
    
    // MARK:- Gender
    
    @objc func gender(_ sender: UITapGestureRecognizer) {

        if isGenderSelected == false{
            self.isGenderSelected = true
        }else if isGenderSelected == true{
            self.isGenderSelected = false
        }
    }


    
    @objc private func checkboxAction(sender: UIButton) {
        if self.isChecked == false{
            self.isChecked = true
        }else{
            self.isChecked = false
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
        self.countryText.placeholder = Constants.string.icnumber.localize()
        self.referralCodeText.placeholder = Constants.string.referralCode.localize()
        self.timeZone.placeholder = Constants.string.emergencycontact.localize()
        self.termsbtn.setTitle(Constants.string.termsconditions.localize(), for: .normal)

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
        self.timeZone.delegate = self
        self.referralCodeText.delegate = self
        self.navigationController?.view.addSubview(nextView)
    }
    
    
    
    
    private func addGustureforNextBtn(){
        
        let nextBtnGusture = UITapGestureRecognizer(target: self, action: #selector(nextBtnTapped(sender:)))
        
        self.nextView.addGestureRecognizer(nextBtnGusture)
    }
    
    
    @IBAction private func ChangeCountryCode() {
        
        let navController = UINavigationController(rootViewController: countryList)
        self.present(navController, animated: true, completion: nil)
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
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterFirstName.localize())
            return
        }
        guard let lastName = lastNameText.text, !lastName.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterLastName.localize())
            return
        }
       
        guard let phoneNumber = phoneNumber.text, !phoneNumber.isEmpty, let mobile = Int(phoneNumber)  else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterMobileNumber.localize())
            return
        }
        guard let password = passwordText.text, !password.isEmpty, password.count>=4 && password.count<=18 else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterPassword.localize())
            return
        }
        
        guard password.count>=4 && password.count<=18 else {
            self.view.make(toast: Constants.string.enterValidpassword.localize()) {
                self.passwordText.becomeFirstResponder()
            }
            return
        }
        guard let confirmPwd = confirmPwdText.text, !confirmPwd.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterConfirmPassword.localize())
            return
        }
        guard confirmPwd == password else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.passwordDonotMatch.localize())
            return
        }
        guard let icnumber = self.countryText.text, !icnumber.isEmpty, icnumber.count==12 else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.entericnumber.localize())
            return
        }
        
        
        guard let emergencycontact = self.timeZone.text, !emergencycontact.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enteremergencycontact.localize())
            return
        }
        guard isChecked != false else{
            self.showToast(string: ErrorMessage.list.termscondition.localize())
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.termscondition.localize())
            return
        }
        
      /*  guard let referralCode = referralCodeText.text, referralCode.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterReferralCode)
            return
        }*/
        
        
        
        let userInfo = Signup()
        userInfo.login_by = LoginType.manual.rawValue
        userInfo.device_id = UUID().uuidString
        userInfo.device_type = DeviceType.ios.rawValue
        userInfo.device_token = deviceTokenString
        userInfo.email = emailtext.text
        userInfo.first_name = firstName
        userInfo.last_name = lastName
        userInfo.mobile = phoneNumber
        userInfo.password = password
        userInfo.emergency_contact_no = emergencycontact
        userInfo.ic_number = icnumber
        userInfo.referral_code = self.referralCodeText.text
        userInfo.emergency_country_code = emergency_country_code
        userInfo.country_code = code
        userInfo.gender = (isGenderSelected == false) ? .Male : .Female

        
//        userInfo =  MakeJson.signUp(loginBy: .manual, email: email, password: password, socialId: nil, firstName: firstName, lastName: lastName, mobile: mobile, emergencycontact: emergencycontact, icnumber: icnumber, referral_code: self.referralCodeText.text, emergency_country_code: emergency_country_code, country_code: code, gender: (isGenderSelected == false) ? "Male" : "Female" )
        
        if self.changedImage != nil, let dataImg = self.changedImage!.pngData() {
           
            self.loader.isHidden = false
            self.presenter?.post(api: .signUp, imageData: [WebConstants.string.picture : dataImg], parameters: userInfo.JSONRepresentation)
            
        } else {
            self.loader.isHidden = false
            self.presenter?.post(api: .signUp, data: userInfo.toData())

        }
        
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

//       self.accountKit = AKFAccountKit(responseType: .accessToken)
//       let akPhone = AKFPhoneNumber(countryCode: "in", phoneNumber: phoneNumber)
//       let accountKitVC = accountKit?.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
//       accountKitVC!.enableSendToFacebook = true
//       self.prepareLogin(viewcontroller: accountKitVC!)
//       self.present(accountKitVC!, animated: true, completion: nil)
      
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
    

//    private func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
//        
//        viewcontroller.delegate = self
//        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
//        viewcontroller.uiManager.theme?()?.buttonTextColor = .white
//        
//    }
    
    // MARK:- Show Image
    
    @IBAction private func changeImage(){
        
        self.showImage { (image) in
            if image != nil {
                self.imageProfile.image = image?.resizeImage(newWidth: 200)
                self.changedImage = self.imageProfile.image
            }
        }
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
        DispatchQueue.main.async {
            self.loader.isHidden = true
            UIApplication.shared.keyWindow?.makeToast(message)
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

//extension SignUpUserTableViewController : AKFViewControllerDelegate {
//
//    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
//        viewController.dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
//        viewController.dismiss(animated: true, completion: nil)
//    }
//
//    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
//        func dismiss() {
//            viewController.dismiss(animated: true) { }
//            self.loader.isHidden = false
////            self.presenter?.post(api: .signUp, data: self.userInfo?.toData())
//        }
//        if accountKit != nil {
//            accountKit!.requestAccount({ (account, error) in
//                if let phoneNumber = account?.phoneNumber {
//                    var mobileString = phoneNumber.stringRepresentation()
//                    if mobileString.hasPrefix("+") {
//                        mobileString.removeFirst()
//                        if let mobileInt = Int(mobileString) {
//                            self.userInfo?.mobile = mobileInt
//                            self.userInfo?.country_code = "+\(account?.phoneNumber?.countryCode ?? "")"
//                        }
//                    }
//                }
//                dismiss()
//                return
//                //print("--->>",account?.phoneNumber.)
//               // print("--->>>",error)
//            })
//        }else {
//            dismiss()
//        }
//
//    }
//
//}

// MARK:- UITextFieldDelegate

extension SignUpUserTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
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


//MARK:- Country List Delegate

extension SignUpUserTableViewController : CountryListDelegate {
    
    func selectedCountry(country: Country) {
        self.countrycode.setTitle("+" + country.phoneExtension, for: .normal)
        //self.userInfo?.emergency_country_code = "+" + country.phoneExtension
        emergency_country_code = "+\(country.phoneExtension)"
        print(emergency_country_code ?? "")
    }
    
}

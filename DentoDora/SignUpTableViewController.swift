//
//  SignUpUserTableViewController.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SignUpUserTableViewController: UITableViewController {
    
    @IBOutlet var firstNameText: HoshiTextField!
    @IBOutlet var emailtext: HoshiTextField!
    @IBOutlet var lastNameText: HoshiTextField!
    
    @IBOutlet var passwordText: HoshiTextField!
    
    @IBOutlet var confirmPwdText: HoshiTextField!
    
    @IBOutlet var countryText: HoshiTextField!
    
    @IBOutlet var timeZone: HoshiTextField!
    
    @IBOutlet var referralCodeText: HoshiTextField!
    
    @IBOutlet var businessLabel: UILabel!
    @IBOutlet var outStationLabel: UILabel!
    @IBOutlet var personalLabel: UILabel!
    @IBOutlet var businessimage: UIImageView!
    
    @IBOutlet var phoneNumber: HoshiTextField!
    @IBOutlet var personalimage: UIImageView!
    
    @IBOutlet var nextView: UIView!
    
    @IBOutlet var nextImage: UIImageView!
    
    @IBOutlet var BusinessView: UIView!
    @IBOutlet var personalView: UIView!
    
    
    private var tripType : TripType =  .Business {
        
        didSet {
            
            self.businessimage.image = tripType == .Business ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            self.personalimage.image = tripType == .Personal ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            
        }
    }
    
    
    var presenter : PostPresenterInputProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        localize()
        SetNavigationcontroller()
    }
    
    
}


extension SignUpUserTableViewController {
    
    private func loadSignUpAPI(){
        
        
    }
    
    private func localize(){
        self.firstNameText.placeholder = Constants.string.first.localize()
        self.lastNameText.placeholder = Constants.string.last.localize()
        self.emailtext.placeholder = Constants.string.emailPlaceHolder.localize()
        self.passwordText.placeholder = Constants.string.password
        self.confirmPwdText.placeholder = Constants.string.ConfirmPassword.localize()
        self.countryText.placeholder = Constants.string.country.localize()
        self.timeZone.placeholder = Constants.string.timeZone.localize()
        self.referralCodeText.placeholder = Constants.string.referalCode.localize()
        self.businessLabel.text = Constants.string.business.localize()
        self.personalLabel.text = Constants.string.personal.localize()
        
    }
    
    func SetNavigationcontroller(){
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = "Enter the details you used to register"
        
        // self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(self.backButtonClick))
    }
    
    
    
    
    private func addGustureforNextBtn(){
        
        
        let nextBtnGusture = UITapGestureRecognizer(target: self, action: #selector(nextBtnTapped(sender:)))
        
        self.nextView.addGestureRecognizer(nextBtnGusture)
    }
    
    
    private func addGustureForRadioBtn(){
        let BusinessradioGusture = UITapGestureRecognizer(target: self, action: #selector(RatioButtonTapped(sender:)))
        self.personalView.addGestureRecognizer(BusinessradioGusture)
    }
    
    @IBAction func RatioButtonTapped (sender: UITapGestureRecognizer){
        
        guard let currentView = sender.view else {
            return
        }
        
        self.tripType = currentView == BusinessView ? .Business : .Personal
        
    }
    
    
    @IBAction func nextBtnTapped(sender : UITapGestureRecognizer){
        guard let firstName = self.firstNameText.text, firstName.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterFirstName)
            return
        }
        guard let lastName = lastNameText.text, lastName.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterLastName)
            return
        }
        guard let email = emailtext.text, email.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterEmail)
            return
        }
        guard let password = passwordText.text, password.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterPassword)
            return
        }
        guard let phoneNumber = phoneNumber.text, phoneNumber.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterMobileNumber)
            return
        }
        guard let confirmPwd = confirmPwdText.text, confirmPwd.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterConfirmPassword)
            return
        }
        guard let country = countryText.text, country.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterCountry)
            return
        }
        guard let timeZone = timeZone.text, timeZone.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterTimezone)
            return
        }
       /* guard let referralCode = referralCodeText.text, referralCode.isEmpty else {
            UIApplication.shared.keyWindow?.makeToast(ErrorMessage.list.enterReferralCode)
            return
        } */
        
        //self.presenter?.post(api: .signUp, data: MakeJson. )
        self.present(id: Storyboard.Ids.DrawerController, animation: true)
    }
    
    
}




//
//  LaunchViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import AccountKit

class LaunchViewController: UIViewController {
    
    
    @IBOutlet private var buttonSignIn : UIButton!
    @IBOutlet private var buttonSignUp : UIButton!
    @IBOutlet private var buttonSocialLogin : UIButton!
    @IBOutlet private var labelVersion : UILabel!
    
    //private weak var viewWalkThrough : WalkThroughView?
    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    private var mobile: String?
    private var countryCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    
}


//MARK:- Methods

extension LaunchViewController {
    
    //MARK:- Initial Loads
    
    private func initialLoads(){
      
        self.setLocalization()
        self.setDesigns()
        self.buttonSignIn.addTarget(self, action: #selector(self.buttonSignInAction), for: .touchUpInside)
        self.buttonSignUp.addTarget(self, action: #selector(self.buttonSignUpAction), for: .touchUpInside)
        self.buttonSocialLogin.addTarget(self, action: #selector(self.buttonSocialLoginAction), for: .touchUpInside)
        User.main.loginType = LoginType.manual.rawValue // Set default login as manual
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        self.labelVersion.text = "App Version" + " " + appVersion! 

    }
    
    
    //MARK:-Set Font Family
    private func setDesigns(){
       Common.setFont(to: self.buttonSignIn, isTitle: true)
       Common.setFont(to: self.buttonSignUp, isTitle: true)
        Common.setFont(to: labelVersion,size : 9.0)
       Common.setFont(to: self.buttonSocialLogin)
       buttonSignIn.setTitleColor(.white, for: .normal)
       buttonSignUp.setTitleColor(.white, for: .normal)
        
    }
    
    //MARK:- Method Localize Strings
    
    private func setLocalization(){
       
       buttonSignUp.setTitle(Constants.string.signUp.localize(), for: .normal)
       buttonSignIn.setTitle(Constants.string.signIn.localize(), for: .normal)
       buttonSocialLogin.setTitle(Constants.string.orConnectWithSocial.localize(), for: .normal)
        
    }
    
    
    @IBAction private func buttonSignInAction(){

        self.push(id: Storyboard.Ids.EmailViewController, animation: true)
        
    }
    
    @IBAction private func buttonSignUpAction() {
        
        self.showAccountKit { (ph,code) in
            self.mobile = ph
            self.countryCode = code
            let verify = Request()
            verify.mobile = ph
            verify.type = "user"
            self.presenter?.post(api: .verifyMobile, data: verify.toData())
        }
    }
    
    @IBAction private func buttonSocialLoginAction(){
        
        self.push(id: Storyboard.Ids.SocialLoginViewController, animation: true)
        
    }
}

extension LaunchViewController : PostViewProtocol {
    
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


extension LaunchViewController : UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
}


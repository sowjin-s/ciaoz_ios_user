//
//  LaunchViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    @IBOutlet private var buttonSignIn : UIButton!
    @IBOutlet private var buttonSignUp : UIButton!
    @IBOutlet private var buttonSocialLogin : UIButton!
    
    //private weak var viewWalkThrough : WalkThroughView?
    
    
    
    var presenter: PostPresenterInputProtocol?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        driverAppExist()
    }

    // if driver app exist need to show warning alert
    func driverAppExist() {
        let app = UIApplication.shared
        let bundleId = "com.appoets.tranxit.user://"
        
        if app.canOpenURL(URL(string: bundleId)!) {
            let appExistAlert = UIAlertController(title: "", message: "You are using both user and provider apps in same device. So app may not work properly ", preferredStyle: .actionSheet)
            
            appExistAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (Void) in
                print("App is install")
            }))
            present(appExistAlert, animated: true, completion: nil)
        }
        else {
            print("App is not installed")
        }
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
    }
    
    
    //MARK:-Set Font Family
    private func setDesigns(){
       Common.setFont(to: self.buttonSignIn, isTitle: true)
       Common.setFont(to: self.buttonSignUp, isTitle: true)
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
    
    @IBAction private func buttonSignUpAction(){
        
        self.push(id: Storyboard.Ids.SignUpTableViewController, animation: true)
        
    }
    
    @IBAction private func buttonSocialLoginAction(){
        
        self.push(id: Storyboard.Ids.SocialLoginViewController, animation: true)
        
    }
    
  
}

extension LaunchViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
    }
    
}


extension LaunchViewController : UIScrollViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
}



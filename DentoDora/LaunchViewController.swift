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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
     }

    
}


//MARK:- Methods

extension LaunchViewController {
    
    //MARK:- Initial Loads
    
    private func initialLoads(){
      
        self.setLocalization()
        self.setDesigns()
    }
    
    
    //MARK:-Set Font Family
    private func setDesigns(){
        
       buttonSignIn.titleLabel?.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 16)
       buttonSignUp.titleLabel?.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 20)
       buttonSignIn.setTitleColor(.white, for: .normal)
       buttonSignUp.setTitleColor(.white, for: .normal)
        
    }
    
    //MARK:- Method Localize Strings
    
    private func setLocalization(){
       
       buttonSignUp.setTitle(Constants.string.signUp.localize(), for: .normal)
       buttonSignIn.setTitle(Constants.string.signIn.localize(), for: .normal)
       buttonSocialLogin.setTitle(Constants.string.orConnectWithSocial.localize(), for: .normal)
        
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



//
//  SocailLoginViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Google

class SocialLoginViewController: UITableViewController {
    
    
    
    private let tableCellId = "SocialLoginCell"
    
    private lazy var loader : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
        self.navigationController?.isNavigationBarHidden = false
    }

}

// MARK:- Methods

extension SocialLoginViewController {
    
    
    private func initialLoads() {
        
       self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        
    }
    
    
    private func localize() {
        
        self.navigationItem.title = Constants.string.chooseAnAccount.localize()
    }
    
    
    // MARK:- Socail Login
    
    private func didSelect(at indexPath : IndexPath) {
        
        switch (indexPath.section,indexPath.row) {
       
        case (0,0):
            self.facebookLogin()
        case (0,1):
            self.googleLogin()
        default:
            break
        }
        
    }
    
    
    // MARK:- Google Login
    
    private func googleLogin(){
        
        self.loader.isHidden = false
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    // MARK:- Facebook Login
    
    private func facebookLogin() {
        
       
        
        
    }
    
    
    
}

// MARK:- TableView

extension SocialLoginViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellId, for: indexPath) as? SocialLoginCell {

            tableCell.labelTitle.text = (indexPath.row == 0 ? Constants.string.facebook : Constants.string.google).localize()
            tableCell.imageViewTitle.image = indexPath.row == 0 ? #imageLiteral(resourceName: "fb_icon") : #imageLiteral(resourceName: "google_icon")
            return tableCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 70
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         self.didSelect(at: indexPath)
         tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

//MARK:- Google Implementation


extension SocialLoginViewController : GIDSignInDelegate, GIDSignInUIDelegate{
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        self.loader.isHidden = true
        
        guard user != nil else {
            return
        }
        
        print(user.profile, error)
        
        //  UserData.main.set(name: String.removeNil(user.profile.name), email: String.removeNil(user.profile.email),image: String.removeNil(user.profile.imageURL(withDimension: 50).absoluteString))
        
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        self.loader.isHidden = true
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        present( viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
}






class SocialLoginCell : UITableViewCell {
    
    @IBOutlet weak var imageViewTitle : UIImageView!
    @IBOutlet weak var labelTitle : UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDesign()
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        Common.setFont(to: self.labelTitle, isTitle: true)
    }
    
}


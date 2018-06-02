//
//  SideBarTableViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    @IBOutlet private var imageViewProfile : UIImageView!
    @IBOutlet private var labelName : UILabel!
    @IBOutlet private var labelEmail : UILabel!
    @IBOutlet private var viewShadow : UIView!
    @IBOutlet private weak var profileImageCenterContraint : NSLayoutConstraint!

   // private let sideBarList = [Constants.string.payment,Constants.string.yourTrips,Constants.string.coupon,Constants.string.wallet,Constants.string.passbook,Constants.string.settings,Constants.string.help,Constants.string.share,Constants.string.inviteReferral,Constants.string.faqSupport,Constants.string.termsAndConditions,Constants.string.privacyPolicy,Constants.string.logout]
    
       private let sideBarList = [Constants.string.payment,Constants.string.yourTrips,Constants.string.coupon,Constants.string.wallet,Constants.string.passbook,Constants.string.settings,Constants.string.help,Constants.string.share,Constants.string.logout]
    
    private let cellId = "cellId"
    
    private lazy var loader : UIView = {
        
        return createActivityIndicator(self.view)
        
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
        self.setValues()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setDesigns()
    }
   
}

// MARK:- Methods

extension SideBarTableViewController {
    
    private func initialLoads() {
        
       // self.drawerController?.fadeColor = UIColor
        self.drawerController?.shadowOpacity = 0.2
        let fadeWidth = self.view.frame.width*(0.2)
        self.profileImageCenterContraint.constant = 0//-(fadeWidth/3)
        self.drawerController?.drawerWidth = Float(self.view.frame.width - fadeWidth)
        self.viewShadow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewAction)))
       
    }
    
    // MARK:- Set Designs
    
    private func setDesigns(){
        
        self.viewShadow.addShadow()
        self.imageViewProfile.makeRoundedCorner()
        
    }
    
    
    //MARK:- SetValues
    
    private func setValues(){
        
        Cache.image(forUrl: baseUrl+"/storage/"+String.removeNil(User.main.picture)) { (image) in
               DispatchQueue.main.async {
                self.imageViewProfile.image = image == nil ? #imageLiteral(resourceName: "userPlaceholder") : image
            }
        }
        self.labelName.text = String.removeNil(User.main.firstName)+" "+String.removeNil(User.main.lastName)
        self.labelEmail.text = User.main.email
    }
    
    
    
    // MARK:- Localize
    private func localize(){
        
        self.tableView.reloadData()

    }
    
    // MARK:- ImageView Action
    
    @IBAction private func imageViewAction() {
        
        let homeVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.ProfileViewController)
        (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(homeVC, animated: true)
        self.drawerController?.closeSide()
        
    }
    
    
    // MARK:- Selection Action For TableView
    
    private func select(at indexPath : IndexPath) {
        
        switch (indexPath.section,indexPath.row) {
            
        case (0,0):
            self.push(to: Storyboard.Ids.PaymentViewController)
        case (0,1):
            fallthrough
        case (0,4):
            if let vc = self.drawerController?.getViewController(for: .none)?.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.YourTripsPassbookViewController) as? YourTripsPassbookViewController {
                vc.isYourTripsSelected = indexPath.row == 1
                self.drawerController?.getViewController(for: .none)?.navigationController?.pushViewController(vc, animated: true)
            }
        case (0,2):
            self.push(to: Storyboard.Ids.CouponViewController)
        case (0,3):
            self.push(to: Storyboard.Ids.WalletViewController)
        case (0,5):
            self.push(to: Storyboard.Ids.SettingTableViewController)
        case (0,6):
            self.push(to: Storyboard.Ids.HelpViewController)
        case (0,7):
            break
        case (0,8):
            self.logout()
            
        default:
            break
        }
        
    }
    
    private func push(to identifier : String) {
        
         self.drawerController?.getViewController(for: .none)?.push(id: identifier, animation: true)
        
    }
    
    
    // MARK:- Logout
    
    private func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.areYouSure.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            self.loader.isHidden = false
            forceLogout()
        }
        
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        
        alert.view.tintColor = .primary
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


// MARK:- TableView

extension SideBarTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
         let tableCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
         tableCell.textLabel?.textColor = .secondary
         tableCell.textLabel?.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 10)
         tableCell.textLabel?.text = sideBarList[indexPath.row].localize()
         return tableCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.select(at: indexPath)
        self.drawerController?.closeSide()
    }
    
    
    
}


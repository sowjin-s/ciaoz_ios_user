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
    @IBOutlet private var viewShadow : UIView!

    private let sideBarList = [Constants.string.payment,Constants.string.yourTrips,Constants.string.coupon,Constants.string.wallet,Constants.string.passbook,Constants.string.settings,Constants.string.help,Constants.string.share,Constants.string.inviteReferral,Constants.string.faqSupport,Constants.string.termsAndConditions,Constants.string.privacyPolicy,Constants.string.logout]
    
    private let cellId = "cellId"
    

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
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setDesigns()
    }
   
}

// MARK:- Methods

extension SideBarTableViewController {
    
    private func initialLoads() {
        
    }
    
    // MARK:- Set Designs
    
    private func setDesigns(){
        
        self.viewShadow.addShadow()
        self.imageViewProfile.makeRoundedCorner()
        
    }
    
    // MARK:- Localize
    private func localize(){
        
        self.tableView.reloadData()

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
    
}


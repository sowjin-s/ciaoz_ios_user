//
//  yourTripViewController.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class YourTripsPassbookViewController: UIViewController {
    
    @IBOutlet var pastBtn: UIButton!
    
    //@IBOutlet var pastUnderLineView: UIView!
    @IBOutlet var upCommingBtn: UIButton!
    
    //@IBOutlet var upCommingUnderLineView: UIView!
    @IBOutlet var tripTabelView: UITableView!
    @IBOutlet private var underLineView: UIView!
    @IBOutlet private var tableViewList : UITableView!
    
    var isYourTripsSelected = true // Boolean Handle Passbook and Yourtrips list
    private var isFirstBlockSelected = true {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.underLineView.frame.origin.x = self.isFirstBlockSelected ? 0 : (self.view.bounds.width/2)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerCell()
        switchViewAction()
    }
    
    
}

extension YourTripsPassbookViewController {
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = (isYourTripsSelected ? Constants.string.yourTrips : Constants.string.passbook).localize()
        self.localize()
    }
 
    private func localize(){
        
        self.pastBtn.setTitle( isYourTripsSelected ? Constants.string.past.localize() : Constants.string.walletHistory.localize(), for: .normal)
        self.upCommingBtn.setTitle(isYourTripsSelected ? Constants.string.upcoming.localize() : Constants.string.couponHistory.localize(), for: .normal)
        
    }
    
    private func registerCell(){
        
        tripTabelView.register(UINib(nibName: XIB.Names.YourTripCell, bundle: nil), forCellReuseIdentifier: XIB.Names.YourTripCell)
        tripTabelView.register(UINib(nibName: XIB.Names.PassbookTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.PassbookTableViewCell)
        
    }
    
    
    private func switchViewAction(){
       // self.pastUnderLineView.isHidden = false
        self.isFirstBlockSelected = true
        self.pastBtn.tag = 1
        self.upCommingBtn.tag = 2
        self.pastBtn.addTarget(self, action: #selector(ButtonTapped(sender:)), for: .touchUpInside)
        self.upCommingBtn.addTarget(self, action: #selector(ButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @IBAction func ButtonTapped(sender: UIButton){
        
        self.isFirstBlockSelected = sender.tag == 1
        tableViewList.reloadData()
    }
}

extension YourTripsPassbookViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.getCell(for: indexPath, in: tableView)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (isYourTripsSelected ? 220.0 : 120)*(UIScreen.main.bounds.height/568)
    }
    
    private func getCell(for indexPath : IndexPath, in tableView : UITableView)->UITableViewCell {
        
        if isYourTripsSelected {
            if let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.YourTripCell, for: indexPath) as? YourTripCell {
                cell.isPastButton = isFirstBlockSelected
                return cell
            }
        } else {
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.PassbookTableViewCell, for: indexPath) as? PassbookTableViewCell {
                cell.isWalletSelected = isFirstBlockSelected
                return cell
            }
            
        }
        return UITableViewCell()
        
    }
    
    
}
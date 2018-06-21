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
    //@IBOutlet var tripTabelView: UITableView!
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
    
    lazy var loader  : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    
    private var datasourceYourTripsUpcoming = [Request]()
    private var datasourceYourTripsPast = [Request]()
    private var datasourceCoupon = [CouponWallet]()
    private var datasourceWallet = [CouponWallet]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        switchViewAction()
//    }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//    }
    
}

extension YourTripsPassbookViewController {
    
    private func initalLoads() {
        self.registerCell()
        self.switchViewAction()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = (isYourTripsSelected ? Constants.string.yourTrips : Constants.string.passbook).localize()
        self.localize()
        self.loader.isHidden = false
       
        if isYourTripsSelected {
            self.presenter?.get(api: .upcomingList, parameters: nil)
            self.presenter?.get(api: .historyList, parameters: nil)
        } else {
            self.presenter?.get(api: .walletPassbook, parameters: nil)
            self.presenter?.get(api: .couponPassbook, parameters: nil)
        }
        self.setDesign()
    }
    
    // MARK:- Set Design
    
    private func setDesign () {
        
        Common.setFont(to: pastBtn, isTitle: true)
        Common.setFont(to: upCommingBtn, isTitle:  true)
    }
    
 
    private func localize(){
        
        self.pastBtn.setTitle( isYourTripsSelected ? Constants.string.past.localize() : Constants.string.walletHistory.localize(), for: .normal)
        self.upCommingBtn.setTitle(isYourTripsSelected ? Constants.string.upcoming.localize() : Constants.string.couponHistory.localize(), for: .normal)
        
    }
    
    private func registerCell(){
        
        tableViewList.register(UINib(nibName: XIB.Names.YourTripCell, bundle: nil), forCellReuseIdentifier: XIB.Names.YourTripCell)
        tableViewList.register(UINib(nibName: XIB.Names.PassbookTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.PassbookTableViewCell)
        
    }
    
    
    // MARK:- Empty View
    
    private func checkEmptyView() {
        
        self.tableViewList.backgroundView = {
           
            if self.getData().count == 0 {
                let label = Label(frame: UIScreen.main.bounds)
                label.numberOfLines = 0
                Common.setFont(to: label, isTitle: true)
                label.center = UIApplication.shared.keyWindow?.center ?? .zero
                label.backgroundColor = .clear
                label.textColorId = 2
                label.textAlignment = .center
                label.text = {
                    
                    if isYourTripsSelected {
                        return (isFirstBlockSelected ? Constants.string.noPastTrips : Constants.string.noUpcomingTrips).localize()
                    } else {
                        return (isFirstBlockSelected ? Constants.string.noWalletHistory : Constants.string.noCouponDetail).localize()
                    }
                }()
                return label
            } else {
                return nil
            }
            
        }()
        
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
        self.reloadTable()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.checkEmptyView()
            self.tableViewList.reloadData()
        }
    }
    
}

// MARK:- UITableViewDelegate

extension YourTripsPassbookViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.getCell(for: indexPath, in: tableView)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (isYourTripsSelected ? (215.0-(isFirstBlockSelected ? 20 : 0)) : 120)//*(UIScreen.main.bounds.height/568)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard isYourTripsSelected else { return }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.YourTripsDetailViewController) as? YourTripsDetailViewController, self.getData().count>indexPath.row, let idValue = self.getData()[indexPath.row].id {
            vc.isUpcomingTrips = !isFirstBlockSelected
            vc.setId(id: idValue)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    private func getCell(for indexPath : IndexPath, in tableView : UITableView)->UITableViewCell {
        
        if isYourTripsSelected {
            if let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.YourTripCell, for: indexPath) as? YourTripCell {
                cell.isPastButton = isFirstBlockSelected
                let datasource = (self.isFirstBlockSelected ? self.datasourceYourTripsPast : self.datasourceYourTripsUpcoming)
                if datasource.count>indexPath.row{
                    cell.set(values: datasource[indexPath.row])
                }
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
    
    private func getData()->[Request] {
        
        if isYourTripsSelected {
            return (isFirstBlockSelected ? self.datasourceYourTripsPast : self.datasourceYourTripsUpcoming)
        } else {
            return (isFirstBlockSelected ? self.datasourceYourTripsPast : self.datasourceYourTripsUpcoming)
        }
        
    }
    
    
}

// MARK:- PostviewProtocol

extension YourTripsPassbookViewController : PostViewProtocol  {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print("Called", #function)
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getRequestArray(api: Base, data: [Request]) {
        print("Called", #function,data)
        
        if api == .historyList {
            self.datasourceYourTripsPast = data
        } else if api == .upcomingList {
            self.datasourceYourTripsUpcoming = data
        }
        reloadTable()
    }
    
    func getCouponWallet(api: Base, data: [CouponWallet]) {
        
        if api == .couponPassbook {
            self.datasourceCoupon = data
        } else if api == .walletPassbook {
            self.datasourceWallet = data
        }
        reloadTable()
    }
    
    
    
}


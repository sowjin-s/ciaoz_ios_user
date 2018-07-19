//
//  PaymentViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import Stripe
//import IQKeyboardManagerSwift

class PaymentViewController: UITableViewController {
    
    @IBOutlet private var buttonAddPayments : UIButton!
    
    private let tableCellId = "tableCellId"
    
    private let headers = [Constants.string.paymentMethods] //Constants.string.yourCards
    
    var isChangingPayment = false
   
    var isEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        self.localize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //self.isEnabled = IQKeyboardManager.shared.enable
        //IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}

//MARK:- Methods
extension PaymentViewController {
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: (self.isChangingPayment ? #imageLiteral(resourceName: "close-1") : #imageLiteral(resourceName: "back-icon")).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonAction))
        self.navigationItem.title = Constants.string.payment.localize()
        self.setDesign()
        self.buttonAddPayments.addTarget(self, action: #selector(self.buttonPaymentAction), for: .touchUpInside)
        
    }
    
    @IBAction private func backButtonAction() {
        
        if isChangingPayment {
            self.navigationController?.popOrDismiss(animation: true)
        } else {
            self.popOrDismiss(animation: true)
        }
        
    }
    
    
    // MARK:- Set Design
    
    private func setDesign () {
        
        Common.setFont(to: buttonAddPayments)
    }
    
    
    private func localize() {
      
        buttonAddPayments.setTitle(Constants.string.addCardPayments.localize(), for: .normal)
        
    }
    
    // Payment Button Action
    
    @IBAction private func buttonPaymentAction() {
        
        let theme = STPTheme.default()
        theme.primaryForegroundColor = .primary
        
        let config = STPPaymentConfiguration()
        config.requiredBillingAddressFields = .none
        
        let cardController = STPAddCardViewController(configuration: config, theme: theme)
        cardController.delegate = self
        cardController.navigationItem.title = cardController.navigationItem.title?.localize()
        self.navigationController?.pushViewController(cardController, animated: true)
    }
    
}

//MARK:- Table
extension PaymentViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellId, for: indexPath) as? PaymentCell {
            
            tableCell.imageViewPayment.image = indexPath.section == 0 ? #imageLiteral(resourceName: "money_icon") : #imageLiteral(resourceName: "visa")
            tableCell.labelPayment.text = indexPath.section == 0 ? 	Constants.string.cash.localize() : "****123"
            return tableCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section].localize()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
}

// MARK:- STPAddCardViewControllerDelegate

extension PaymentViewController : STPAddCardViewControllerDelegate {
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        
        print("Stripe Token :: -> ",token);
        addCardViewController.popOrDismiss(animation: true)
        
    }
    
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        
        DispatchQueue.main.async {
            
           addCardViewController.popOrDismiss(animation: true)
            
        }
        
    }
}




class PaymentCell : UITableViewCell {
    
    @IBOutlet var imageViewPayment : UIImageView!
    @IBOutlet var labelPayment : UILabel!
}


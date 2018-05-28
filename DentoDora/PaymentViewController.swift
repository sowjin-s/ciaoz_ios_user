//
//  PaymentViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class PaymentViewController: UITableViewController {
    
    @IBOutlet private var buttonAddPayments : UIButton!
    
    private let tableCellId = "tableCellId"
    
    private let headers = [Constants.string.paymentMethods, Constants.string.yourCards]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        self.localize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

//MARK:- Methods
extension PaymentViewController {
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.payment.localize()
    }
    
    private func localize() {
        buttonAddPayments.setTitle(Constants.string.addCardPayments.localize(), for: .normal)
        
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


class PaymentCell : UITableViewCell {
    
    @IBOutlet var imageViewPayment : UIImageView!
    @IBOutlet var labelPayment : UILabel!
}


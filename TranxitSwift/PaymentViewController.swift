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
    var onclickPayment : ((CardEntity?)->Void)? // Change payment Mode from Request
    private var cardsList = [CardEntity]()
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
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
        self.presenter?.get(api: .getCards, parameters: nil)
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
          self.push(id: Storyboard.Ids.AddCardViewController, animation: true)
        
//        let theme = STPTheme.default()
//        theme.primaryForegroundColor = .primary
//        
//        let config = STPPaymentConfiguration()
//        config.requiredBillingAddressFields = .none
//        
//        let cardController = STPAddCardViewController(configuration: config, theme: theme)
//        cardController.delegate = self
//        cardController.navigationItem.title = cardController.navigationItem.title?.localize()
//        self.navigationController?.pushViewController(cardController, animated: true)
    }
    
    // MARK:- Swipe Action
    @available(iOS 11.0, *)
    private func swipeAction(at indexPath : IndexPath) -> UISwipeActionsConfiguration?{
        
        guard indexPath.section == 1 else { return nil}
        let entity = self.cardsList[indexPath.row]
        let contextAction = UIContextualAction(style: .normal, title: Constants.string.delete.localize()) { (action, view, bool) in
            let alert = UIAlertController(title: "XXXX-XXXX-XXXX-"+String.removeNil(self.cardsList[indexPath.row].last_four), message: Constants.string.areYouSureCard.localize(), preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: Constants.string.remove.localize(), style: .destructive, handler: { (_) in
                self.loader.isHidden = false
                var cardEntity = CardEntity()
                cardEntity.card_id = entity.card_id
                cardEntity._method = Constants.string.delete.uppercased()
                self.presenter?.post(api: .deleteCard, data: cardEntity.toData())
                bool(true)
            }))
            alert.addAction(UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil))
            alert.view.tintColor = .primary
            self.present(alert, animated: true, completion: nil)
        }
        contextAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [contextAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
        
    }
    
}

//MARK:- Table
extension PaymentViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: self.tableCellId, for: indexPath) as? PaymentCell {
            
            if indexPath.section == 0 {
                tableCell.imageViewPayment.image =  #imageLiteral(resourceName: "money_icon")
                tableCell.labelPayment.text = Constants.string.cash.localize()
            } else if self.cardsList.count > indexPath.row {
                tableCell.imageViewPayment.image =  #imageLiteral(resourceName: "visa")
                tableCell.labelPayment.text = "XXXX-XXXX-XXXX-"+String.removeNil(cardsList[indexPath.row].last_four)
                tableCell.accessoryType = cardsList[indexPath.row].is_default == true.hashValue ? .checkmark : .none
            }
            return tableCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : cardsList.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? headers[section].localize() : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        self.dismiss(animated: true) {
            if indexPath.section == 1, self.cardsList.count > indexPath.row {
                self.onclickPayment?(self.cardsList[indexPath.row])
            } else {
                self.onclickPayment?(nil)
            }
        }
    }
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       return self.swipeAction(at: indexPath)
    }
}

extension PaymentViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getCardEnities(api: Base, data: [CardEntity]) {
        
        self.cardsList = data
        self.loader.isHideInMainThread(true)
        self.tableView.reloadInMainThread()
        
    }
    
    func success(api: Base, message: String?) {
        self.loader.isHideInMainThread(true)
        if api == .deleteCard {
            UIApplication.shared.keyWindow?.makeToast(message)
            self.presenter?.get(api: .getCards, parameters: nil)
        }
    }
}

//// MARK:- STPAddCardViewControllerDelegate
//
//extension PaymentViewController : STPAddCardViewControllerDelegate {
//
//    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
//
//        print("Stripe Token :: -> ",token);
//        addCardViewController.popOrDismiss(animation: true)
//
//    }
//
//
//    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
//
//        DispatchQueue.main.async {
//
//           addCardViewController.popOrDismiss(animation: true)
//
//        }
//
//    }
//}
//
//
//

class PaymentCell : UITableViewCell {
    
    @IBOutlet var imageViewPayment : UIImageView!
    @IBOutlet var labelPayment : UILabel!
}


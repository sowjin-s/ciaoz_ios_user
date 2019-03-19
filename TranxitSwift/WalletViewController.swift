//
//  WalletViewController.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var labelBalance : Label!
    @IBOutlet private weak var textFieldAmount : UITextField!
    @IBOutlet private weak var viewWallet : UIView!
    @IBOutlet private weak var buttonAddAmount : UIButton!
    @IBOutlet var labelWallet: UILabel!
    @IBOutlet var labelAddMoney: UILabel!
    @IBOutlet private var buttonsAmount : [UIButton]!
    @IBOutlet private weak var viewCard : UIView!
    @IBOutlet private weak var labelCard: UILabel!
    @IBOutlet private weak var buttonChange : UIButton!
    
    private var selectedCardEntity : CardEntity?
    var isPaymentInstructionPresent: Bool = false
    var isCloseButtonClick: Bool = false
    var mp = MOLPayLib()
    
    private var isWalletEnabled : Bool = false {
        didSet{
            self.buttonAddAmount.isEnabled = isWalletEnabled
            self.buttonAddAmount.backgroundColor = isWalletEnabled ? .primary : .lightGray
            self.viewCard.isHidden = !isWalletEnabled
        }
    }
    
    private var isWalletAvailable : Bool = false {
        didSet {
            self.buttonAddAmount.isHidden = !isWalletAvailable
            self.viewCard.alpha = CGFloat(isWalletAvailable ? 1 : 0)
            self.viewWallet.alpha = CGFloat(isWalletAvailable ? 1 : 0)
        }
    }
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        //self.isWalletAvailable = User.main.isCardAllowed
        self.isWalletAvailable = true
        
        self.initalLoads()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // IQKeyboardManager.sharedManager().enable = false
    }
    
}

//NSDictionary *params = @{@"amount":_enterAmtTxtfiedl.text, @"card_id":strCardID};

extension WalletViewController {
    
    private func initalLoads() {
        
        self.setWalletBalance()
        //self.presenter?.get(api: .getProfile, parameters: nil)
        self.presenter?.get(api: .wallet, parameters: nil)
        self.view.dismissKeyBoardonTap()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.wallet.localize()
        self.setDesign()
        self.textFieldAmount.placeholder = String.removeNil(User.main.currency)+" "+"\(0)"
        self.textFieldAmount.delegate = self
        for (index,button) in buttonsAmount.enumerated() {
            button.tag = (index*100)+99
            button.setTitle(String.removeNil(String.removeNil(User.main.currency)+" \(button.tag)"), for: .normal)
        }
        self.buttonChange.addTarget(self, action: #selector(self.buttonChangeCardAction), for: .touchUpInside)
        //self.isWalletEnabled = false
        self.isWalletEnabled = true
        KeyboardAvoiding.avoidingView = self.view
        //self.presenter?.get(api: .getCards, parameters: nil)
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelBalance, isTitle: true)
        Common.setFont(to: textFieldAmount)
        Common.setFont(to: labelCard)
        Common.setFont(to: buttonChange)
        buttonChange.setTitle(Constants.string.change.localize(), for: .normal)
        labelAddMoney.text = Constants.string.addAmount.localize()
        labelWallet.text = Constants.string.yourWalletAmnt.localize()
        buttonAddAmount.setTitle(Constants.string.ADDAMT, for: .normal)
        
    }
    
    @IBAction private func buttonAmountAction(sender : UIButton) {
        
        textFieldAmount.text = "\(sender.tag)"
    }
    
    private func setCardDetails() {
        if let lastFour = self.selectedCardEntity?.last_four {
          // self.labelCard.text = "XXXX-XXXX-XXXX-"+lastFour
            self.labelCard.text = "MolPay"
            print(lastFour)
        }
        self.labelCard.text = "MolPay"
    }
    
    
    @IBAction private func buttonAddAmountClick() {
        self.view.endEditingForce()
        guard let text = textFieldAmount.text?.replacingOccurrences(of: String.removeNil(User.main.currency), with: "").removingWhitespaces(),  text.isNumber, Int(text)! > 0  else {
            self.view.make(toast: Constants.string.enterValidAmount.localize())
            return
        }
        /* guard self.selectedCardEntity != nil else{
            return
        }*/
        self.loader.isHidden = false
        /* let cardId = self.selectedCardEntity?.card_id
        self.selectedCardEntity?.strCardID = cardId
        self.selectedCardEntity?.amount = text
        self.presenter?.post(api: Base.addMoney, data: self.selectedCardEntity?.toData()) */
        self.addamount(amount: text)
    }
    
    // MARK:- Change Card Action
    
    @IBAction private func buttonChangeCardAction() {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.PaymentViewController) as? PaymentViewController{
            vc.isChangingPayment = true
            vc.isShowCash = false
            vc.onclickPayment = { type, cardEntity in
                self.selectedCardEntity = cardEntity
                self.setCardDetails()
                vc.navigationController?.dismiss(animated: true, completion: nil)
            }
            let navigation = UINavigationController(rootViewController: vc)
            self.present(navigation, animated: true, completion: nil)
        }
    }
    
    
    private func setWalletBalance() {
        DispatchQueue.main.async {
            self.labelBalance.text = String.removeNil(User.main.currency)+" \(User.main.wallet_balance ?? 0)"
        }
    }
    
    
}


extension WalletViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
     //   print(IQKeyboardManager.sharedManager().keyboardDistanceFromTextField)
    }
}

// MARK:- PostViewProtocol

extension WalletViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        Common.storeUserData(from: data)
        storeInUserDefaults()
        self.setWalletBalance()
    }
    
    func getCardEnities(api: Base, data: [CardEntity]) {
        self.selectedCardEntity = data.first
        DispatchQueue.main.async {
            self.setCardDetails()
            //self.isWalletEnabled = !data.isEmpty
            self.isWalletEnabled =  true
           /* if data.isEmpty && User.main.isCardAllowed {
                showAlert(message: Constants.string.addCard.localize(), okHandler: {
                   self.push(id: Storyboard.Ids.AddCardViewController, animation: true)
                }, cancelHandler: nil, fromView: self)
            } */
        }
    }
   
    func getWalletEntity(api: Base, data: WalletEntity?) {
        User.main.wallet_balance = data?.balance
        storeInUserDefaults()
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.setWalletBalance()
            self.textFieldAmount.text = nil
            UIApplication.shared.keyWindow?.makeToast(data?.message)
        }
    }
    
    func getWalletMolpay(api: Base, data: MolpayEntity) {
        DispatchQueue.main.async {
            self.dismiss(animated: true);
            self.loader.isHidden = true
            self.textFieldAmount.text = nil
            UIApplication.shared.keyWindow?.makeToast(data.message)
        }
    }
    
    func getWallet(api: Base, data: walletModel) {
        User.main.wallet_balance = Float(data.wallet_amount ?? "")
        storeInUserDefaults()
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.setWalletBalance()
        }
    }
    
}

extension WalletViewController: MOLPayLibDelegate {
    func transactionResult(_ result: [AnyHashable : Any]!) {
        print("transactionResult result = \(String(describing: result))")
        if(result["status_code"] as? String == "11"){
            self.dismiss(animated: true); // to your failed page
        }else if(result["status_code"] as? String == "00"){
            print("success")
            var params = MolpayEntity()
            params.amount = result["amount"] as? String
            params.transaction_id = result["txn_ID"] as? Int
            print(params)
            self.presenter?.post(api: .molpay, data: params.toData())
            //self.dismiss(animated: true); // to your success page
            self.loader.isHidden = true
        }else{
            self.dismiss(animated: true); //others
            self.loader.isHidden = true
        }
    }
    
    func addamount(amount: String){
        
        self.isPaymentInstructionPresent = false
        self.isCloseButtonClick = false
        
        let paymentRequestDict: [String:Any] = [
            "mp_amount": amount,
            "mp_username": "api_SB_ciaoz2u",
            "mp_password": "api_Cu2z211aiC#",
            "mp_merchant_ID": "SB_ciaoz2u",
            "mp_app_name": "ciaoz2u",
            "mp_verification_key": "78d6446bcb253e24c9fbbbb74b82bccd",
            "mp_order_ID": "1",
            "mp_currency": "MYR",
            "mp_country": "MY",
            "mp_channel": "",
            "mp_bill_description": "Test Check",
            "mp_bill_name": "Ranjith",
            "mp_bill_email": "email@domain.com",
            "mp_bill_mobile": "+1234567",
            "mp_channel_editing": NSNumber.init(booleanLiteral:false),
            "mp_editing_enabled": NSNumber.init(booleanLiteral:false),
            "mp_dev_mode": NSNumber.init(booleanLiteral:true),
            "mp_transaction_id": "",
            "mp_request_type": "",
            "mp_sandbox_mode": NSNumber.init(booleanLiteral:false)
        ]
        self.mp = MOLPayLib(delegate:self, andPaymentDetails: paymentRequestDict)
        
        self.mp.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(self.closemolpay)
        )
        self.mp.navigationItem.hidesBackButton = true
        
        let nc = UINavigationController()
        nc.viewControllers = [mp]
        
        self.present(nc, animated: false) {
            print("---presented")
        }
    }
    
    @IBAction func closemolpay(sender: UIBarButtonItem) {
        // Closes MOLPay
        self.mp.closemolpay()
        isCloseButtonClick = true
        print("---Close: \(NSNumber.init(booleanLiteral: true))")
    }
    
}


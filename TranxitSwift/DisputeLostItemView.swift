//
//  ReasonView.swift
//  User
//
//  Created by CSS on 26/07/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class DisputeLostItemView: UIView, UIScrollViewDelegate {
    
    @IBOutlet private weak var tableview : UITableView!
    @IBOutlet private weak var scrollView : UIScrollView!
    @IBOutlet private weak var labelTitle : UILabel!
    @IBOutlet private weak var buttonClose : UIButton!
    @IBOutlet private weak var buttonSubmit : UIButton!
    
    var textView:UITextView?
    var keyboardShow:Bool=false
    
    var isDispute:Bool = false
    var onClickClose : ((Bool)->Void)?
    var requestID:Int=0
    private var datasource:[String] = []
    //[Constants.string.planChanged,Constants.string.bookedAnotherCab,Constants.string.driverDelayed,Constants.string.lostWallet, Constants.string.othersIfAny]
    private var selectedIndexPath = IndexPath(row: -1, section: -1)
    
    private var isShowTextView = false {
        didSet {
            self.tableview.tableFooterView = isShowTextView ? self.getTextView() : nil
        }
    }
    
    var didSelectReason : ((String)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.alpha = 1.0
        self.tableview.dataSource = self
        self.tableview.delegate = self
        self.tableview.register(UINib(nibName: XIB.Names.disputeCell, bundle: nil), forCellReuseIdentifier: XIB.Names.disputeCell)
        self.isShowTextView = true
        Common.setFont(to: labelTitle, isTitle: true, size: 18)
        Common.setFont(to: buttonSubmit)
        self.buttonSubmit.backgroundColor = .primary
        self.buttonSubmit.setTitle(Constants.string.submit.uppercased().localize(), for: .normal)
        buttonClose.addTarget(self, action: #selector(self.buttonCloseAction), for: .touchUpInside)
        buttonSubmit.addTarget(self, action: #selector(self.buttonSubmitAction), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK:- Methods
extension DisputeLostItemView {
    
    // MARK:- Creating Dynamic Text View
    private func getTextView()->UIView{
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height/2))
        textView = UITextView(frame: CGRect(x: 16, y: 8, width: self.frame.width-32, height: (self.frame.height/2.5)))
        Common.setFont(to: textView!)
        textView?.enablesReturnKeyAutomatically = true
        textView?.delegate = self
        textView?.borderLineWidth = 1
        textView?.cornerRadius = 10
        textView?.borderColor = .lightGray
        textView?.toolbarPlaceholder = Constants.string.writeSomething.localize()
        scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height)
        view.addSubview(textView!)
        return view
    }
    
    func set(value:[String],isDispute:Bool,requestID:Int)  {
        for reason in value {
            self.datasource.append(reason)
        }
        self.requestID = requestID
        self.labelTitle.text = isDispute ? Constants.string.dispute.localize() : Constants.string.lostItem.localize()
        self.isDispute = isDispute
        self.tableview.reloadInMainThread()
    }
    // MARK:- Button Done Action
    
    @IBAction private func buttonCloseAction() {
        self.onClickClose!(true)
    }
    
    @IBAction private func buttonSubmitAction() {
        if isDispute && self.selectedIndexPath.row < 0{
            showToast(msg: Constants.string.disputeMsg.localize())
            return
        }
        guard let text = textView?.text, !text.isEmpty else {
            showToast(msg: Constants.string.enterComment.localize())
            return
        }
        var Dispute = DisputeList()
        Dispute.user_id = User.main.id
        Dispute.request_id = requestID
        if isDispute {
            Dispute.dispute_type = "user"
            Dispute.dispute_name = self.datasource[selectedIndexPath.row]
            Dispute.comments = textView?.text
            self.presenter?.post(api: .postDispute, data: Dispute.toData())
        }else{
            Dispute.lost_item_name = textView?.text
            self.presenter?.post(api: .lostItem, data: Dispute.toData())
        }
        
    }
    
    func showToast(msg:String) {
        self.makeToast(msg, duration: 1.0, position: .center)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if !keyboardShow {
                keyboardShow = true
                self.frame.origin.y -= keyboardSize.height
            }
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.frame.origin.y = (UIApplication.shared.keyWindow?.frame.size.height)!-self.frame.size.height
        keyboardShow = false
    }
    
}

// MARK:- UITableViewDelegate
extension DisputeLostItemView : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableview.dequeueReusableCell(withIdentifier: XIB.Names.disputeCell, for: indexPath) as? DisputeCell, self.datasource.count > indexPath.row {
            tableCell.lblTitle.text = self.datasource[indexPath.row]
            return tableCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        var cell = tableView.cellForRow(at: selectedIndexPath) as? DisputeCell
//        tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .none
        cell?.imageRadio.image = #imageLiteral(resourceName: "circle-shape-outline")
        self.selectedIndexPath = indexPath
        cell = tableView.cellForRow(at: selectedIndexPath) as? DisputeCell
//        tableView.cellForRow(at: selectedIndexPath)?.accessoryType = .checkmark
        cell?.imageRadio.image = #imageLiteral(resourceName: "radio-on-button")
        if (indexPath.row == (datasource.count-1)) {
            if !self.isShowTextView {
                self.isShowTextView = true
            }
        } else {
            self.didSelectReason?(self.datasource[indexPath.row])
        }
    }
}


extension DisputeLostItemView : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
}


extension DisputeLostItemView:PostViewProtocol{
    func onError(api: Base, message: String, statusCode code: Int) {
        self.showToast(msg: message)
    }
    
    func getDispute(api: Base, data: DisputeList) {
        print(data.message as Any)
        self.onClickClose!(true)
    }
   
    
}


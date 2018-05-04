//
//  ProfileViewController.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    @IBOutlet private weak var imageViewProfile : UIImageView!
    @IBOutlet private weak var textFieldFirst : HoshiTextField!
    @IBOutlet private weak var textFieldLast : HoshiTextField!
    @IBOutlet private weak var textFieldPhone : HoshiTextField!
    @IBOutlet private weak var textFieldEmail : HoshiTextField!
    @IBOutlet private weak var buttonSave : UIButton!
    @IBOutlet private weak var buttonChangePassword : UIButton!
    @IBOutlet private weak var labelBusiness : UILabel!
    @IBOutlet private weak var labelPersonal : UILabel!
    @IBOutlet private weak var labelTripType : UILabel!
    @IBOutlet private weak var imageViewBusiness : UIImageView!
    @IBOutlet private weak var imageViewPersonal : UIImageView!
    @IBOutlet private weak var viewBusiness : UIView!
    @IBOutlet private weak var viewPersonal : UIView!
    
    
    private var tripType :TripType = .Business {
        
        didSet {
            
            self.imageViewBusiness.image = tripType == .Business ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            self.imageViewPersonal.image = tripType == .Personal ? #imageLiteral(resourceName: "radio-on-button") : #imageLiteral(resourceName: "circle-shape-outline")
            
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.initialLoads()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayout()
    }
    
}

// MARK:- Methods

extension ProfileViewController {
    
    private func initialLoads() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.localize()
        self.setDesign()
        self.view.dismissKeyBoardonTap()
        
    }
    
    //MARK:- Set Designs
    
    private func setDesign() {
        
        var attributes : [ NSAttributedStringKey : Any ] = [.font : UIFont(name: FontCustom.clanPro_NarrMedium.rawValue, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)]
        attributes.updateValue(UIColor.white, forKey: NSAttributedStringKey.foregroundColor)
        self.buttonSave.setAttributedTitle(NSAttributedString(string: Constants.string.save.uppercased().localize(), attributes: attributes), for: .normal)
        self.viewPersonal.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
        self.viewBusiness.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.setTripTypeAction(sender:))))
    }
    
    // MARK:- Trip Type Action
    
  @IBAction private func setTripTypeAction(sender : UITapGestureRecognizer) {
        
        guard let senderView = sender.view else { return }
        
        self.tripType = senderView == viewPersonal ? .Personal : .Business
        
    }
    
    private func setLayout(){
        
        self.imageViewProfile.makeRoundedCorner()
        
    }
    
    
    // MARK:- Localize
    
    private func localize() {
        
        self.textFieldFirst.placeholder = Constants.string.first.localize()
        self.textFieldLast.placeholder = Constants.string.last.localize()
        self.textFieldPhone.placeholder = Constants.string.phoneNumber.localize()
        self.textFieldEmail.placeholder = Constants.string.email.localize()
        self.labelTripType.text = Constants.string.tripType.localize()
        self.labelBusiness.text = Constants.string.bussiness.localize()
        self.labelPersonal.text = Constants.string.personal.localize()
        self.buttonChangePassword.setTitle(Constants.string.lookingToChangePassword.localize(), for: .normal)
        
    }
    
    
}


// MARK:- TextField Delegate

extension ProfileViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
       return textField.resignFirstResponder()
    }
    
}


// MARK:- ScrollView Delegate

extension ProfileViewController {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.contentOffset.y<0 else { return }
        
        print(scrollView.contentOffset)
        
        let inset = abs(scrollView.contentOffset.y/imageViewProfile.frame.height)
        
        self.imageViewProfile.transform = CGAffineTransform(scaleX: 1+inset, y: 1+inset)
        
    }
    
}


//// MARK:- Tableview
//
//extension ProfileViewController {
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        if indexPath.row == 3 {  // Trip Type
//
//            self.setTripType()
//        }
//
//    }
//
//}

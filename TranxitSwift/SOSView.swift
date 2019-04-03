//
//  SOSView.swift
//  TranxitUser
//
//  Created by Suganya on 02/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class SOSView: UIView {

    @IBOutlet private weak var btnfamily : UIButton!
    @IBOutlet private weak var btnService : UIButton!
    @IBOutlet private weak var btnSafety : UIButton!
    @IBOutlet private weak var btnCall: UIButton!
    @IBOutlet private weak var btnCancel : UIButton!
    @IBOutlet private weak var labelfamily : UILabel!
    @IBOutlet private weak var labelService: UILabel!
    @IBOutlet private weak var labelSafety : UILabel!
    @IBOutlet private weak var labelTitle : UILabel!
    private var sosInfo: sosModel?
    private var contactArray = [String]()
    private var customerService: String?
    private var safetyAuth: String?
    private var selectedSos: String?
    
    let select = #imageLiteral(resourceName: "radioselected").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    let unselect = #imageLiteral(resourceName: "uncheck_icon").withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    
    private var choosenSOS : Int = 0 {
        didSet {
            
            switch choosenSOS {
            case 1:
                btnfamily.setImage(unselect, for: .normal)
                btnService.setImage(select, for: .normal)
                btnSafety.setImage(unselect, for: .normal)
            case 2:
                
                btnfamily.setImage(unselect, for: .normal)
                btnService.setImage(unselect, for: .normal)
                btnSafety.setImage(select, for: .normal)
            default:
                btnfamily.setImage(select, for: .normal)
                btnService.setImage(unselect, for: .normal)
                btnSafety.setImage(unselect, for: .normal)
            }
        }
        
    }
     var onClickCall:((String?)->Void)?
     var onClickCancel:(()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        self.localize()
        self.setDesign()
    }

}

extension SOSView {
    
    private func initialLoads() {
        
        self.choosenSOS = 0
        [self.btnCancel,self.btnCall].forEach { $0?.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .touchUpInside)}
        [self.btnfamily,self.btnSafety,btnService].forEach { $0?.addTarget(self, action: #selector(self.choosenSOS(sender:)), for: .touchUpInside)}
    }
    
    func set(value: sosModel) {
        
        self.sosInfo = value
     
        self.contactArray.append(value.sos?.emergency_contact ?? "")
        self.contactArray.append("911")
        self.contactArray.append("911")
        self.selectedSos = contactArray[choosenSOS]
    }
    
    private func setDesign() {
        [self.btnCancel,self.btnCall].forEach { Common.setFont(to: $0!,isTitle: true)}
        [self.labelSafety,self.labelfamily,self.labelService].forEach { Common.setFont(to: $0!,size: 14.0)}

        
    }
    
    private func localize() {
        self.labelTitle.text = Constants.string.SOSAlert.localize()
        self.labelfamily.text = Constants.string.familycontact.localize()
        self.labelSafety.text = Constants.string.safetyAuth.localize()
        self.labelService.text = Constants.string.customerService.localize()
        self.btnCall.setTitle(Constants.string.call.localize().uppercased(), for: .normal)
        self.btnCancel.setTitle(Constants.string.Cancel.uppercased(), for: .normal)
        [self.btnCall,self.btnCancel].forEach { $0?.backgroundColor = .primary}
    }
    
    @objc private func buttonAction(sender:UIButton){
        
        if sender == btnCancel {
          self.onClickCancel?()
            
        } else {
          self.onClickCall?(self.selectedSos)
        }
        
    }
    
    func getSOS(){}
    
    @objc private func choosenSOS(sender: UIButton){
        
        self.choosenSOS = sender.tag
        self.selectedSos = contactArray[choosenSOS]
        
    }
}

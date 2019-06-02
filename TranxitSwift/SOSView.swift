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
    @IBOutlet private weak var labelAirportTitle : UILabel!
    @IBOutlet private weak var fareTblVw : UITableView!
    @IBOutlet private weak var viewFare : UIView!
    @IBOutlet private weak var viewSOS : UIView!
    @IBOutlet private weak var viewBg : UIView!
    
    private var sosInfo: sosModel?
    private var contactArray = [String]()
    private var customerService: String?
    private var safetyAuth: String?
    private var selectedSos: String?
    var showAirportFare: Bool?
    var fareinfo: [AirportFare]?
    
    
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
        self.fareTblVw.reloadData()
    }

}

extension SOSView {
    
    private func initialLoads() {
        self.fareTblVw.delegate = self
        self.fareTblVw.dataSource = self
        self.choosenSOS = 0
        self.viewBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.closeAction)))
        [self.btnCancel,self.btnCall].forEach { $0?.addTarget(self, action: #selector(self.buttonAction(sender:)), for: .touchUpInside)}
        [self.btnfamily,self.btnSafety,btnService].forEach { $0?.addTarget(self, action: #selector(self.choosenSOS(sender:)), for: .touchUpInside)}
    }
    
    func set(value: sosModel) {
        
        self.sosInfo = value
        self.viewFare.isHidden = true
        self.viewSOS.isHidden = false
        self.contactArray.append(value.sos?.emergency_contact ?? "")
        self.contactArray.append("911")
        self.contactArray.append("911")
        self.selectedSos = contactArray[choosenSOS]
    }
    
    //MARK:- Airport fare
    func setAirportFare(with value: EstimateFare?) {
        self.viewFare.isHidden = !showAirportFare!
        self.viewSOS.isHidden = true
        if value != nil {
            self.fareinfo = value!.airport_fares
            print(fareinfo)
        }
        self.fareTblVw.separatorStyle = .none
        self.fareTblVw.reloadData()
    }
    
    
    private func setDesign() {
        [self.btnCancel,self.btnCall].forEach { Common.setFont(to: $0!,isTitle: true)}
        [self.labelSafety,self.labelfamily,self.labelService].forEach { Common.setFont(to: $0!,size: 14.0)}

        
    }
    
    private func localize() {
        self.labelTitle.text = Constants.string.SOSAlert.localize()
        self.labelAirportTitle.text = Constants.string.airportFare.localize()
        self.labelfamily.text = Constants.string.familycontact.localize()
        self.labelSafety.text = Constants.string.safetyAuth.localize()
        self.labelService.text = Constants.string.customerService.localize()
        self.btnCall.setTitle(Constants.string.call.localize().uppercased(), for: .normal)
        self.btnCancel.setTitle(Constants.string.Cancel.uppercased(), for: .normal)
        [self.btnCall,self.btnCancel].forEach { $0?.backgroundColor = .primary}
        Common.setFont(to: labelAirportTitle)
        Common.setFont(to: labelService)
        Common.setFont(to: labelAirportTitle)
        Common.setFont(to: labelfamily)
        Common.setFont(to: labelSafety)
        
    }
    
    @objc private func buttonAction(sender:UIButton){
        
        if sender == btnCancel {
          self.onClickCancel?()
            
        } else {
          self.onClickCall?(self.selectedSos)
        }
        
    }
    
    @objc private func choosenSOS(sender: UIButton){
        
        self.choosenSOS = sender.tag
        self.selectedSos = contactArray[choosenSOS]
        
    }
    @objc private func closeAction(){
        
       self.onClickCancel?()
        
    }
    
    
}

extension SOSView : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fareinfo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let value  = "• Driver \(self.fareinfo?[indexPath.row].radius ?? "0") ---> \(User.main.currency ?? .Empty) \(self.fareinfo?[indexPath.row].price ?? "0")"
        cell.textLabel!.text = value
        Common.setFont(to: cell.textLabel)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    

}

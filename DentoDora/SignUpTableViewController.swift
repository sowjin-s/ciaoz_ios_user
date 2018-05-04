//
//  SignUpTableViewController.swift
//  User
//
//  Created by CSS on 27/04/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SignUpTableViewController: UITableViewController {
    
    @IBOutlet weak var EmailTxt: HoshiTextField!
    @IBOutlet var lastNametext: HoshiTextField!
    @IBOutlet weak var FirstName: HoshiTextField!
    @IBOutlet var PhoneNumber: HoshiTextField!
    @IBOutlet var Licenseimage: UIImageView!
    @IBOutlet var VehicleMake: HoshiTextField!
    @IBOutlet var VehicleImage: UIImageView!
    @IBOutlet weak var Emailtext: HoshiTextField!
    @IBOutlet var VehicleModel: HoshiTextField!
    @IBOutlet var vehicleColor: HoshiTextField!
    @IBOutlet var radioButtonImage1: UIImageView!
    @IBOutlet var shuttleView: UIView!
    @IBOutlet var outStationView: UIView!
    @IBOutlet var rentalView: UIView!
    @IBOutlet var agreeLable: UILabel!
    @IBOutlet var agreeCheckBoximage: UIImageView!
    @IBOutlet var outStationRadiontn2: UIImageView!
    @IBOutlet var twoWay: UILabel!
    @IBOutlet var oneWaylabel: UILabel!
    @IBOutlet var OutStationRadioBtn1: UIImageView!
    @IBOutlet var shuttleLable: UILabel!
    @IBOutlet var outStationLable: UILabel!
    @IBOutlet var rendelLable: UILabel!
    @IBOutlet var radioButtonimage2: UIImageView!
    @IBOutlet var radioButtonImage: UIImageView!
    @IBOutlet var ReferralCode: HoshiTextField!
    @IBOutlet var carCategory: HoshiTextField!
    @IBOutlet var CityName: HoshiTextField!
    @IBOutlet var vehicleplateNum: HoshiTextField!
    @IBOutlet var VehicleYear: HoshiTextField!
    @IBOutlet var twoWayView: UIView!
    @IBOutlet var oneWayView: UIView!
    @IBOutlet var driveProofView: UIView!
    @IBOutlet var vehiclePhotoView: UIView!
    @IBOutlet var checkBoxView: UIView!
    
    var presenter : PostPresenterInputProtocol? //declare presenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addtabgustureForRadioBtn()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setTag()
        self.SetNavigationcontroller()
        self.unsetSelection()
        self.setfont()
        self.addCheckBoxBtn()
        self.imagePicker()
        
    }
    
}

extension SignUpTableViewController {
    
    func unsetSelection(){
        self.tableView.allowsSelection = false
    }
    
    func addtabgustureForRadioBtn(){   //MARK:- Add tabgusture for imageview
        
        //MARK:- TRIP TYPE RadioButton
        let tapgustureRentelView = UITapGestureRecognizer(target: self, action: #selector(addtapgusture(sender:)))
        let tapgustureOutstationView = UITapGestureRecognizer(target: self, action: #selector(addtapgusture(sender:)))
        let tapgustureShutleView = UITapGestureRecognizer(target: self, action: #selector(addtapgusture(sender:)))
        self.rentalView.addGestureRecognizer(tapgustureRentelView)
        self.outStationView.addGestureRecognizer(tapgustureOutstationView)
        self.shuttleView.addGestureRecognizer(tapgustureShutleView)
        
        
        //MARK:- ONEWAY and TWOWAY RadioButton
        let oneWayTapgusture = UITapGestureRecognizer(target: self, action: #selector(oneAndTwoway(sender:)))
        let twoWayTapgusture = UITapGestureRecognizer(target: self, action: #selector(oneAndTwoway(sender:)))
        self.oneWayView.addGestureRecognizer(oneWayTapgusture)
        self.twoWayView.addGestureRecognizer(twoWayTapgusture)
        
    }
    private func setTag(){
        // MARK:- set tag for all views,images ,buttons
        self.oneWayView.tag = 1
        self.twoWayView.tag = 2
        
        self.vehiclePhotoView.tag = 1
        self.driveProofView.tag = 2
        
        self.rentalView.tag = 1
        self.outStationView.tag = 2
        self.shuttleView.tag = 3
    }
    func imagePicker(){
        //MARK:- set taggusture for imageView
        let imagepickerTapgusture = UITapGestureRecognizer(target: self, action: #selector(vehicleimageTapped(sender:)))
        let driveProof = UITapGestureRecognizer(target: self, action: #selector(vehicleimageTapped(sender:)))
        self.vehiclePhotoView.addGestureRecognizer(imagepickerTapgusture)
        self.driveProofView.addGestureRecognizer(driveProof)
        
        
    }
    
    @objc func vehicleimageTapped(sender: UITapGestureRecognizer){
        
        self.showImage { (image) in
            if sender.view?.tag == 1{
                self.VehicleImage.image = image
            }else {
                self.Licenseimage.image = image
            }
        }
        
    }
    
    
    
    func addCheckBoxBtn(){
        
        let checkBoxTapGusture = UITapGestureRecognizer(target: self, action: #selector(checkboxAction(sender:)))
        self.checkBoxView.addGestureRecognizer(checkBoxTapGusture)
    }
    
    @objc func checkboxAction(sender: UITapGestureRecognizer){
        if agreeCheckBoximage.image == UIImage(named: "check-box-empty"){
            self.agreeCheckBoximage.image = UIImage(named: "check")
        }else {
            self.agreeCheckBoximage.image = UIImage(named: "check-box-empty")
        }
        
    }
    
    
    @objc func oneAndTwoway (sender: UITapGestureRecognizer){
        if sender.view?.tag == 1 {
            self.OutStationRadioBtn1.image = UIImage(named: "radio-on-button")
            self.outStationRadiontn2.image = UIImage(named: "circle-shape-outline")
        }else if sender.view?.tag == 2 {
            self.OutStationRadioBtn1.image = UIImage(named: "circle-shape-outline")
            self.outStationRadiontn2.image = UIImage(named: "radio-on-button")
        }
        
    }
    
    
    @objc func addtapgusture (sender : UITapGestureRecognizer){
        
        if sender.view?.tag == 1 {
            self.radioButtonImage.image = UIImage(named: "radio-on-button")
            self.radioButtonImage1.image = UIImage(named: "circle-shape-outline")
            self.radioButtonimage2.image = UIImage(named: "circle-shape-outline")
        }else if sender.view?.tag == 2 {
            self.radioButtonImage.image = UIImage(named: "circle-shape-outline")
            self.radioButtonImage1.image = UIImage(named: "radio-on-button")
            self.radioButtonimage2.image = UIImage(named: "circle-shape-outline")
        }else if sender.view?.tag == 3 {
            self.radioButtonImage.image = UIImage(named: "circle-shape-outline")
            self.radioButtonImage1.image = UIImage(named: "circle-shape-outline")
            self.radioButtonimage2.image = UIImage(named: "radio-on-button")
        }
        
    }
    
    
    
    
    func setfont(){ //MARK:- Set Common font for lable and text
        self.Emailtext.font = UIFont(name: "Raleway-Medium", size: 30)
    }
    
    
    func SetNavigationcontroller(){
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = "Enter the details"
       // var systemInfo = utsname()
        // self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(self.backButtonClick))
    }
    
   
}


extension SignUpTableViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    
}


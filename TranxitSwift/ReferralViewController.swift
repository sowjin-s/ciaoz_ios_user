
//
//  ReferralViewController.swift
//  TranxitUser
//
//  Created by Ranjith on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class ReferralViewController: UIViewController {

    @IBOutlet private var referraltitleLabel : UILabel!
    @IBOutlet private var referraltextLabel : UILabel!
    @IBOutlet private var referralCodeLabel : UILabel!
    @IBOutlet private weak var buttonShare : UIButton!

    private lazy var loader  : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialLoads()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK:- Methods

extension ReferralViewController {

    // MARK:- Initial Loads
    private func initialLoads() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.referral.localize()
        self.setDesign()
        self.localize()
        self.getFromApi()
        self.buttonShare.addTarget(self, action: #selector(self.buttonShareAction), for: .touchUpInside)

    }
    
    // MARK:- Localize
    private func localize() {
        self.buttonShare.setTitle(Constants.string.share.uppercased().localize(), for: .normal)
        self.referraltitleLabel.text = Constants.string.referYourFriend.localize()
        self.referraltextLabel.text = Constants.string.sharereferral.localize()
    }
    
    @IBAction private func buttonShareAction() {
        
        guard let code = referralCodeLabel.text, !code.isEmpty else {
            
            UIApplication.shared.keyWindow?.make(toast: Constants.string.referralCodeError.localize())
            return
        }
        
        // text to share
        let text = "Use Referral Code \(self.referralCodeLabel.text ?? "")"
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    // MARK:- Set Design
    private func setDesign () {
        
        Common.setFont(to: referraltitleLabel, isTitle: true)
        Common.setFont(to: referraltextLabel, isTitle: false)
        Common.setFont(to: referralCodeLabel, isTitle: true)
    }
    
    
    // MARK:- Get Data From Api
    private func getFromApi() {
        
        self.loader.isHideInMainThread(false)
        self.presenter?.get(api: .referral, parameters: nil)

    }
    
    
}

// MARK:- PostviewProtocol

extension ReferralViewController : PostViewProtocol  {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print("shgdhjs")
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getReferral(api: Base, data: referralModel) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            print("skdhj")
            self.referralCodeLabel.text = data.referral_code
        }
    }
    
    
//    func onError(api: Base, message: String, statusCode code: Int) {
//        print("sjdjh")
//    }
//
//    func Conreferal(api: Base, data: referralModel) {
//        print("sdgjs")
//    }
}

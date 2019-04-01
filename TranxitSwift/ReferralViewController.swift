
//
//  ReferralViewController.swift
//  TranxitUser
//
//  Created by Ranjith on 28/02/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import Branch

class ReferralViewController: UIViewController {

    @IBOutlet private var referraltitleLabel : UILabel!
    @IBOutlet private var referraltextLabel : UILabel!
    @IBOutlet private var referralCodeLabel : UILabel!
    @IBOutlet private weak var buttonShare : UIButton!
    @IBOutlet private weak var buttonCopy : UIButton!
    private var referalURL : String?
    
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
        
       // self.createShareLink()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.referral.localize()
        self.setDesign()
        self.localize()
        self.getFromApi()
        self.buttonShare.addTarget(self, action: #selector(self.buttonShareAction), for: .touchUpInside)
        self.buttonCopy.addTarget(self, action: #selector(self.copyAction), for: .touchUpInside)


    }
    
    // MARK:- Localize
    private func localize() {
        self.buttonShare.setTitle(Constants.string.share.uppercased().localize(), for: .normal)
        self.buttonCopy.setTitle(Constants.string.copyText.uppercased().localize(), for: .normal)
        self.referraltitleLabel.text = Constants.string.referYourFriend.localize()
        self.referraltextLabel.text = Constants.string.sharereferral.localize()
    }
    
    
    @objc func copyAction(){
    
        UIPasteboard.general.string = referralCodeLabel.text
        self.view.makeToast("COPIED")
        
    }
    

    @IBAction private func buttonShareAction() {
        
        guard let code = referralCodeLabel.text, !code.isEmpty else {
            
            UIApplication.shared.keyWindow?.make(toast: Constants.string.referralCodeError.localize())
            return
        }
        
     
        let buo = BranchUniversalObject.init(canonicalIdentifier: "content/12345")
        buo.title = "Ciaoz User"
        //buo.contentDescription = "Your friend invited you to download"
       // buo.imageUrl = "https://lorempixel.com/400/400"
        //buo.publiclyIndex = true
        //buo.locallyIndex = true
        buo.contentMetadata.customMetadata["referral"] = self.referralCodeLabel.text
        
        let lp: BranchLinkProperties = BranchLinkProperties()
        lp.channel = "facebook"
        lp.feature = "sharing"
       
        buo.getShortUrl(with: lp) { (url, error) in
            print(url ?? "")
            let text = "Your friend invited you to download CiaozUser" + " " + url!
            self.referalURL = text
            
            // set up activity view controller
            let textToShare: [Any] = [self.referalURL!]
            self.share(items: textToShare)
        }
        
//        buo.showShareSheet(with: lp,andShareText: referalURL,from: self) { (activityType, completed) in
//            if (completed) {
//                print(String(format: "Completed sharing to %@", activityType!))
//            } else {
//                print("Link sharing cancelled")
//            }
//        }
        
        
    }
    
    // MARK:- Share Items
    
    func share(items : [Any]) {
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
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

//
//  AccountKit.swift
//  TranxitUser
//
//  Created by Suganya on 03/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import AccountKit


class AccountKit: NSObject {

    private var mobile: String?
    private var countryCode: String?
    private var accountKit : AKFAccountKit?
    var delegateAC: (UIViewController&AKFViewController)?

    private lazy var  loader = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? UIView())
    }()

    init(vc: UIViewController) {
        super.init()
        self.accountKit = AKFAccountKit(responseType: .accessToken)
        let akPhone = AKFPhoneNumber(countryCode: "+60", phoneNumber: "")
        let accountKitVC = accountKit?.viewControllerForPhoneLogin(with: akPhone, state: UUID().uuidString)
        accountKitVC!.enableSendToFacebook = true
        self.prepareLogin(viewcontroller: accountKitVC!)
        vc.present(accountKitVC!, animated: true, completion: nil)
    }
    
    func prepareLogin(viewcontroller : UIViewController&AKFViewController) {
        viewcontroller.uiManager = AKFSkinManager(skinType: .contemporary, primaryColor: .primary)
        viewcontroller.uiManager.theme?()?.buttonTextColor = .white
    }

}

/*extension AccountKit : AKFViewControllerDelegate {

    func viewControllerDidCancel(_ viewController: (UIViewController & AKFViewController)!) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: (UIViewController & AKFViewController)!, didFailWithError error: Error!) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        func dismiss() {
            viewController.dismiss(animated: true) { }
        }
        if accountKit != nil {
            accountKit!.requestAccount({ (account, error) in
                if let phoneNumber = account?.phoneNumber?.phoneNumber {

                    self.mobile = phoneNumber
                    self.countryCode = "+\(account?.phoneNumber?.countryCode ?? "")"
                    let verify = Request()
                    verify.mobile = phoneNumber
                    verify.type = "user"
                    self.presenter?.post(api: .verifyMobile, data: verify.toData())

                }
                dismiss()
                return
            })
        }else {
            dismiss()
        }

    }

}*/

extension AccountKit : PostViewProtocol {

    func onError(api: Base, message: String, statusCode code: Int) {

    }

    func getVerifiedMobile(api: Base, data: successLog?) {
        self.loader.isHidden = true
        if data?.status != 0 {
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.make(toast: "Mobile number Already Exists")
            }
        } else {
            UIApplication.shared.keyWindow?.make(toast: "Mobile number Verified")

            let signup = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.SignUpTableViewController) as? SignUpUserTableViewController
            signup?.mobile = mobile
            signup?.code = countryCode
            UIApplication.topViewController()?.navigationController?.pushViewController(signup!, animated: true)
        }
    }


}

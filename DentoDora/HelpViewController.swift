//
//  helpViewController.swift
//  User
//
//  Created by CSS on 08/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import MessageUI
import SafariServices
import KWDrawerController

class HelpViewController: UIViewController {
    
    @IBOutlet var supportLabel: UILabel!
    @IBOutlet var helpImage: UIImageView!
//    @IBOutlet var callImage: UIImageView!
//    @IBOutlet var messageImage: UIImageView!
//    @IBOutlet var webImage: UIImageView!
    @IBOutlet var HelpQuotesLabel: UILabel!
    
    @IBOutlet var viewButtons: [UIView]!
    
    
    @IBOutlet var callButton: UIButton!
    
    @IBOutlet var messageButton: UIButton!
    
    @IBOutlet var webButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
        buttonAction()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        viewButtons.forEach({ $0.makeRoundedCorner() })
    }
    
}

extension HelpViewController {
    
    private func initalLoads() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.help.localize()
    }
    
    private func buttonAction(){
        self.callButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.messageButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.webButton.addTarget(self, action: #selector(Buttontapped(sender:)), for: .touchUpInside)
        self.callButton.tag = 1
        self.messageButton.tag = 2
        self.webButton.tag = 3
        
    }
    
    @IBAction func Buttontapped(sender: UIButton){
        if sender.tag == 1{
            Common.call(to: supportNumber)
        }else if sender.tag == 2{
            self.sendEmail()
            
        }else if sender.tag == 3 {
            
            guard let url = URL(string: baseUrl) else {
                return //be safe
            }
            
            let safariVC = SFSafariViewController(url: url)
         //   safariVC.navigationController?.navigationBar.isHidden = true
            safariVC.delegate = self
            self.present(safariVC, animated: true, completion: nil)
            
//            if #available(iOS 10.0, *) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
            
        }
        
    }
    
    
    
    
}

extension HelpViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["paul@hackingwithswift.com"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}

//MARK:- SFSafariViewControllerDelegate

extension HelpViewController : SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.popOrDismiss(animation: true)
    }
}


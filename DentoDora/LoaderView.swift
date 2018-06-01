//
//  LoaderView.swift
//  User
//
//  Created by CSS on 17/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import PopupDialog

class LoaderView: UIView {

    @IBOutlet private weak var buttonCancelRequest : UIButton!
    @IBOutlet private weak var labelFindingDriver : UILabel!
    @IBOutlet private weak var viewLoader : UIView!
    
    var onCancel : (()->Void)?
    private var lottieView : LottieView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
   
}

extension LoaderView {
    
    private func initialLoads() {
        
        self.buttonCancelRequest.setTitle(Constants.string.cancelRequest.localize().uppercased(), for: .normal)
        self.labelFindingDriver.text = Constants.string.findingDriver.localize()
        self.buttonCancelRequest.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        
        lottieView = LottieHelper().addLottie(file: "bouncy_mapmaker", with: CGRect(origin: .zero, size: CGSize(width: self.viewLoader.frame.width/3, height: self.viewLoader.frame.width/3)))
        lottieView.center = CGPoint(x: viewLoader.frame.width/2, y: viewLoader.frame.height/2)
        lottieView.backgroundColor = .clear
        lottieView.loopAnimation = true
        lottieView.autoReverseAnimation = true
        self.viewLoader.addSubview(lottieView)
        self.lottieView.centerXAnchor.constraint(equalTo: self.viewLoader.centerXAnchor).isActive = true
        self.lottieView.centerYAnchor.constraint(equalTo: self.viewLoader.centerYAnchor).isActive = true
        lottieView.play()
    }
    
    
    func endLoader(){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.lottieView.transform = CGAffineTransform(scaleX: 5, y: 5)
            self.lottieView.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
 
    @IBAction private func cancelButtonClick(){
        
       
        let alert = PopupDialog(title: Constants.string.cancelRequest.localize(), message: Constants.string.cancelRequestDescription.localize())
        let cancelButton =  PopupDialogButton(title: Constants.string.Cancel.localize(), action: {
             alert.dismiss()
        })
        cancelButton.titleColor = .primary
        let sureButton = PopupDialogButton(title: Constants.string.sure.localize()) {
             self.onCancel?()
        }
        sureButton.titleColor = .red
        alert.addButtons([cancelButton,sureButton])
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

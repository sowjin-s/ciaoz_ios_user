//
//  HomeViewController+Extension.swift
//  User
//
//  Created by CSS on 16/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import UIKit

extension HomeViewController {
    
    // MARK:- Show Service View
    
    func showServiceSelectionView() {
        
        if self.serviceSelectionView == nil {
            self.serviceSelectionView = Bundle.main.loadNibNamed(XIB.Names.ServiceSelectionView, owner: self, options: [:])?.first as? ServiceSelectionView
        }
        
        self.serviceSelectionView?.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-self.serviceSelectionView!.frame.height), size: CGSize(width: self.view.frame.width, height: self.serviceSelectionView!.frame.height))
        self.serviceSelectionView?.buttonMore.addTarget(self, action: #selector(self.buttonMoreServiceAction(sender:)), for: .touchUpInside)
        self.serviceSelectionView?.buttonService.addTarget(self, action: #selector(self.buttonMoreServiceAction(sender:)), for: .touchUpInside)
        self.serviceSelectionView?.show(with: .bottom, completion: nil)
        self.view.addSubview(self.serviceSelectionView!)
    }
    
    // MARK:- Service View Button More and Service Action
    
    @IBAction private func buttonMoreServiceAction(sender : UIButton) {
        
        self.serviceSelectionView?.isServiceSelected = sender == self.serviceSelectionView?.buttonService
        
    }
    
    // MARK:- Remove Service View  
    
    func removeServiceView() {
    
        self.serviceSelectionView?.dismissView(onCompletion: {
            self.serviceSelectionView = nil
        })
        
    }
    
    // MARK:- Temporarily Hide Service View
    
    func isMapInteracted(_ isHide : Bool){
       
        UIView.animate(withDuration: 0.2) {
            self.serviceSelectionView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.serviceSelectionView?.frame.height ?? 0))
            self.rideSelectionView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.rideSelectionView?.frame.height ?? 0))
            self.serviceSelectionView?.alpha = isHide ? 0 : 1
            self.viewAddressOuter.alpha = isHide ? 0 : 1
            self.rideSelectionView?.alpha = isHide ? 0 : 1
        }
       
    }
    
    
    // MARK:- Show Ride Now view
    
    func showRideNowView(){
        
        guard self.rideSelectionView == nil  else { return }
        
        self.rideSelectionView = Bundle.main.loadNibNamed(XIB.Names.RequestSelectionView, owner: self, options: [:])?.first as? RequestSelectionView
        self.rideSelectionView?.frame = CGRect(x: 0, y: self.view.frame.height-self.rideSelectionView!.bounds.height, width: self.view.frame.width, height: self.rideSelectionView!.frame.height)
        self.rideSelectionView?.show(with: .bottom, completion: nil)
        self.rideSelectionView?.rideNowAction = {
            self.removeRideNowView()
            self.showLoaderView()
        }
        
        self.rideSelectionView?.scheduleAction = {
            self.schedulePickerView(on: { (date) in
                print(date)
            })
        }
        self.view.addSubview(self.rideSelectionView!)
        
    }
    
    
    // MARK:- Remove RideNow View
    
    func removeRideNowView(){
        
        self.rideSelectionView?.dismissView(onCompletion: {
            self.rideSelectionView = nil
        })
    }
    
    
    // MARK:- Show RideStatus View
    
     func showRideStatusView() {
        
        guard self.rideStatusView == nil else { return }
        
        if let rideStatus = Bundle.main.loadNibNamed(XIB.Names.RideStatusView, owner: self, options: [:])?.first as? RideStatusView {
            
            rideStatus.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-rideStatus.frame.height), size: CGSize(width: self.view.frame.width, height: rideStatus.frame.height))
            rideStatusView = rideStatus
            self.view.addSubview(rideStatus)
            rideStatus.show(with: .bottom, completion: nil)
        }
        
    }
    
    
    // MARK:- Remove RideStatus View
    
    func removeRideStatusView() {
        
        self.rideStatusView?.dismissView(onCompletion: {
            self.rideStatusView = nil
        })
        
    }
    
}

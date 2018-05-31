//
//  HomeViewController+Extension.swift
//  User
//
//  Created by CSS on 16/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import UIKit
import Lottie
import GoogleMaps

extension HomeViewController {
    
    // MARK:- Show Service View
    
    func showServiceSelectionView(with source : [Service]) {
        
        
        if self.serviceSelectionView == nil {
            
            self.serviceSelectionView = Bundle.main.loadNibNamed(XIB.Names.ServiceSelectionView, owner: self, options: [:])?.first as? ServiceSelectionView
            self.serviceSelectionView?.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-self.serviceSelectionView!.frame.height), size: CGSize(width: self.view.frame.width, height: self.serviceSelectionView!.frame.height))
            self.serviceSelectionView?.buttonMore.addTarget(self, action: #selector(self.buttonMoreServiceAction(sender:)), for: .touchUpInside)
            self.serviceSelectionView?.buttonService.addTarget(self, action: #selector(self.buttonMoreServiceAction(sender:)), for: .touchUpInside)
            self.serviceSelectionView?.show(with: .bottom, completion: nil)
            self.view.addSubview(self.serviceSelectionView!)
            
            self.serviceSelectionView?.onClickPricing = { selectedItem in
                if let id = selectedItem?.id {
                    self.service = selectedItem
                    self.getEstimateFareFor(serviceId: id)
                }
                self.removeServiceView()
            }
        }
        
        self.serviceSelectionView?.set(source: source)
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
            self.rideStatusView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.rideStatusView?.frame.height ?? 0))
            self.invoiceView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.invoiceView?.frame.height ?? 0))
            self.ratingView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.ratingView?.frame.height ?? 0))
            
            self.serviceSelectionView?.alpha = isHide ? 0 : 1
            self.viewAddressOuter.alpha = isHide ? 0 : 1
            self.rideSelectionView?.alpha = isHide ? 0 : 1
            self.rideStatusView?.alpha = isHide ? 0 : 1
            self.invoiceView?.alpha = isHide ? 0 : 1
            self.ratingView?.alpha = isHide ? 0 : 1
            
        }
        
    }
    
    
    // MARK:- Show Ride Now view
    
    func showRideNowView(with fare : EstimateFare){
        
        if self.rideSelectionView == nil {
            self.viewAddressOuter.isHidden = true
            self.rideSelectionView = Bundle.main.loadNibNamed(XIB.Names.RequestSelectionView, owner: self, options: [:])?.first as? RequestSelectionView
            self.rideSelectionView?.frame = CGRect(x: 0, y: self.view.frame.height-self.rideSelectionView!.bounds.height, width: self.view.frame.width, height: self.rideSelectionView!.frame.height)
            self.rideSelectionView?.show(with: .bottom, completion: nil)
            self.rideSelectionView?.rideNowAction = { estimateFare in
                self.removeRideNowView()
                if estimateFare != nil {
                    self.createRequest(for: estimateFare!, isScheduled: false, scheduleDate: nil)
                }
            }
            self.rideSelectionView?.scheduleAction = { estimateFare in
                self.schedulePickerView(on: { (date) in
                    print(date)
                    if estimateFare != nil {
                        self.createRequest(for: estimateFare!, isScheduled: true, scheduleDate: date)
                    }
                })
            }
            self.view.addSubview(self.rideSelectionView!)
        }
        
        self.rideSelectionView?.setValues(values: fare)
        
    }
    
    
    // MARK:- Remove RideNow View
    
    func removeRideNowView(){
        
        self.rideSelectionView?.dismissView(onCompletion: {
            self.rideSelectionView = nil
            self.viewAddressOuter.isHidden = false
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
    
    
    // MARK:- Show Invoice View
    
    func showInvoiceView() {
        
        guard self.invoiceView == nil else { return }
        
        if let invoice = Bundle.main.loadNibNamed(XIB.Names.InvoiceView, owner: self, options: [:])?.first as? InvoiceView {
            
            invoice.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-invoice.frame.height), size: CGSize(width: self.view.frame.width, height: invoice.frame.height))
            invoiceView = invoice
            self.view.addSubview(invoiceView!)
            invoiceView?.show(with: .bottom, completion: nil)
        }
        
    }
    
    
    // MARK:- Remove RideStatus View
    
    func removeInvoiceView() {
        
        self.invoiceView?.dismissView(onCompletion: {
            self.invoiceView = nil
        })
        
    }
    
    
    // MARK:- Show RideStatus View
    
    func showRatingView() {
        
        guard self.ratingView == nil else { return }
        
        if let rating = Bundle.main.loadNibNamed(XIB.Names.RatingView, owner: self, options: [:])?.first as? RatingView {
            
            rating.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-rating.frame.height), size: CGSize(width: self.view.frame.width, height: rating.frame.height))
            ratingView = rating
            self.view.addSubview(ratingView!)
            ratingView?.show(with: .bottom, completion: nil)
        }
        
    }
    
    
    // MARK:- Remove RideStatus View
    
    func removeRatingView() {
        
        self.ratingView?.dismissView(onCompletion: {
            self.ratingView = nil
        })
        
    }
    
    
    // MARK:- Show Providers In Current Location
    
    func showProviderInCurrentLocation(with data : [Service]) {
        
        
        for locationData in data where locationData.longitude != nil && locationData.latitude != nil {
            
            let lottieView = LottieView(name: "suv")
            lottieView.frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
            lottieView.loopAnimation = true;
            lottieView.play()
            
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(locationData.latitude!, locationData.longitude!))
            marker.iconView = lottieView
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = mapViewHelper?.mapView
            
            
        }
        
    }
    
    
}

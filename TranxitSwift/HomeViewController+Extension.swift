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
import PopupDialog


extension HomeViewController {
    
    
    // MARK:- Show Ride Now View
    
    func showRideNowView(with source : [Service]) {
        
        guard let sourceLocation = self.sourceLocationDetail?.value, let destinationLocation = self.destinationLocationDetail else { return }
        var selectedPaymentDetail : CardEntity?
        if self.rideNowView == nil {
            
            self.rideNowView = Bundle.main.loadNibNamed(XIB.Names.RideNowView, owner: self, options: [:])?.first as? RideNowView
            self.rideNowView?.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-self.rideNowView!.frame.height), size: CGSize(width: self.view.frame.width, height: self.rideNowView!.frame.height))
            self.rideNowView?.clipsToBounds = false
            self.rideNowView?.show(with: .bottom, completion: nil)
            self.view.addSubview(self.rideNowView!)
            self.isOnBooking = true
            
            self.rideNowView?.onClickRideNow = { service in
                if service != nil {
                    self.createRequest(for: service!, isScheduled: false, scheduleDate: nil, cardEntity: selectedPaymentDetail)
                }
            }
            self.rideNowView?.onClickSchedule = { service in
                self.schedulePickerView(on: { (date) in
                    if service != nil {
                        self.createRequest(for: service!, isScheduled: true, scheduleDate: date,cardEntity: selectedPaymentDetail)
                    }
                })
            }
            self.rideNowView?.onClickChangePayment = {
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.PaymentViewController) as? PaymentViewController{
                    vc.isChangingPayment = true
                    vc.onclickPayment = { cardEntity in
                        selectedPaymentDetail = cardEntity
                        self.rideNowView?.imageViewCard.image = cardEntity == nil ? #imageLiteral(resourceName: "money_icon") : #imageLiteral(resourceName: "visa")
                        self.rideNowView?.labelCardNumber.text = cardEntity == nil ? Constants.string.cash.localize() : "XXXX-XXXX-XXXX-"+String.removeNil(cardEntity?.last_four)
                    }
                    let navigation = UINavigationController(rootViewController: vc)
                    self.present(navigation, animated: true, completion: nil)
                }
            }
        }
        self.rideNowView?.set(source: source)
        self.rideNowView?.setAddress(source: sourceLocation.coordinate, destination: destinationLocation.coordinate)
    }
    
    // MARK:- Remove RideNowView
    
    func removeRideNow() {
        
        self.isOnBooking = false
        self.rideNowView?.dismissView(onCompletion: {
            self.rideNowView = nil
        })
        
    }
    
    
    /*   // MARK:- Show Service View
     
     func showServiceSelectionView(with source : [Service]) {
     
     
     if self.serviceSelectionView == nil {
     
     self.serviceSelectionView = Bundle.main.loadNibNamed(XIB.Names.ServiceSelectionView, owner: self, options: [:])?.first as? ServiceSelectionView
     self.serviceSelectionView?.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-self.serviceSelectionView!.frame.height), size: CGSize(width: self.view.frame.width, height: self.serviceSelectionView!.frame.height))
     self.serviceSelectionView?.buttonMore.addTarget(self, action: #selector(self.buttonMoreServiceAction(sender:)), for: .touchUpInside)
     self.serviceSelectionView?.buttonService.addTarget(self, action: #selector(self.buttonMoreServiceAction(sender:)), for: .touchUpInside)
     self.serviceSelectionView?.show(with: .bottom, completion: nil)
     self.view.addSubview(self.serviceSelectionView!)
     self.isOnBooking = true
     if let source = self.sourceLocationDetail?.value?.coordinate, let destination = self.destinationLocationDetail?.coordinate {
     self.serviceSelectionView?.setAddress(source: source, destination: destination)
     }
     self.serviceSelectionView?.onClickPricing = { selectedItem in
     if let id = selectedItem?.id {
     self.loader.isHidden = false
     self.service = selectedItem
     self.getEstimateFareFor(serviceId: id)
     }
     }
     self.serviceSelectionView?.clipsToBounds = false
     }
     
     self.serviceSelectionView?.set(source: source)
     }
     
     // MARK:- Service View Button More and Service Action
     
     @IBAction private func buttonMoreServiceAction(sender : UIButton) {
     
     self.serviceSelectionView?.isServiceSelected = sender == self.serviceSelectionView?.buttonService
     
     }
     
     // MARK:- Remove Service View
     
     func removeServiceView() {
     
     self.isOnBooking = false
     self.serviceSelectionView?.dismissView(onCompletion: {
     self.serviceSelectionView = nil
     })
     
     } */
    
    // MARK:- Temporarily Hide Service View
    
    func isMapInteracted(_ isHide : Bool){
        
        UIView.animate(withDuration: 0.2) {
            
            
            self.rideStatusView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.rideStatusView?.frame.height ?? 0))
            self.invoiceView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.invoiceView?.frame.height ?? 0))
            //self.ratingView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.ratingView?.frame.height ?? 0))
            self.rideNowView?.frame.origin.y = (self.view.frame.height-(isHide ? 0 : self.rideNowView?.frame.height ?? 0))
            
            
            // self.serviceSelectionView?.alpha = isHide ? 0 : 1
            self.viewAddressOuter.alpha = isHide ? 0 : 1
            self.viewLocationButtons.alpha = isHide ? 0 : 1
            // self.rideSelectionView?.alpha = isHide ? 0 : 1
            self.rideStatusView?.alpha = isHide ? 0 : 1
            self.invoiceView?.alpha = isHide ? 0 : 1
            self.ratingView?.alpha = isHide ? 0 : 1
            self.rideNowView?.alpha = isHide ? 0 : 1
            self.floatyButton?.alpha = isHide ? 0 : 1
            self.reasonView?.alpha = isHide ? 0 : 1
        }
        
    }
    
    
    /*   // MARK:- Show Ride Now view
     s
     func showRideNowView(with fare : EstimateFare){
     
     self.removeServiceView()
     if self.rideSelectionView == nil {
     print("ViewAddressOuter ", #function)
     self.loader.isHidden = true
     self.rideSelectionView = Bundle.main.loadNibNamed(XIB.Names.RequestSelectionView, owner: self, options: [:])?.first as? RequestSelectionView
     self.rideSelectionView?.frame = CGRect(x: 0, y: self.view.frame.height-self.rideSelectionView!.bounds.height, width: self.view.frame.width, height: self.rideSelectionView!.frame.height)
     self.rideSelectionView?.show(with: .bottom, completion: nil)
     self.rideSelectionView?.rideNowAction = { estimateFare in
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
     self.isOnBooking = true
     self.view.addSubview(self.rideSelectionView!)
     }
     
     self.rideSelectionView?.setValues(values: fare)
     
     }
     
     
     // MARK:- Remove RideNow View
     
     func removeRideNowView(){
     
     self.rideSelectionView?.dismissView(onCompletion: {
     self.rideSelectionView = nil
     self.isOnBooking = false
     self.loader.isHidden = true
     })
     } */
    
    
    // MARK:- Show RideStatus View
    
    func showRideStatusView(with request : Request) {
        
        self.removeRideNow()
        self.viewAddressOuter.isHidden = false
        self.viewLocationButtons.isHidden = true
        self.loader.isHidden = true
        print("ViewAddressOuter ", #function)
        if self.rideStatusView == nil, let rideStatus = Bundle.main.loadNibNamed(XIB.Names.RideStatusView, owner: self, options: [:])?.first as? RideStatusView {
            rideStatus.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-rideStatus.frame.height), size: CGSize(width: self.view.frame.width, height: rideStatus.frame.height))
            rideStatusView = rideStatus
            self.view.addSubview(rideStatus)
            self.addFloatingButton(with: rideStatus.frame.height, to: request.provider)
            rideStatus.show(with: .bottom, completion: nil)
        }
        // Change Provider Location 
        if let latitude = request.provider?.latitude, let longitude = request.provider?.longitude {
            self.moveProviderMarker(to: LocationCoordinate(latitude: latitude, longitude: longitude))
        }
        self.buttonSOS.isHidden = !(request.status == .pickedup)
        rideStatusView?.set(values: request)
        rideStatusView?.onClickCancel = {
            self.cancelCurrentRide(isSendReason: true)
        }
        rideStatusView?.onClickShare = {
            self.shareRide()
        }
        
    }
    
    
    // MARK:- Remove RideStatus View
    
    func removeRideStatusView() {
        self.buttonSOS.isHidden = true
        self.rideStatusView?.dismissView(onCompletion: {
            self.rideStatusView = nil
        })
        
    }
    
    
    // MARK:- Show Invoice View
    
    func showInvoiceView(with request : Request) {
        self.buttonSOS.isHidden = false
        if self.invoiceView == nil, let invoice = Bundle.main.loadNibNamed(XIB.Names.InvoiceView, owner: self, options: [:])?.first as? InvoiceView {
            self.viewAddressOuter.isHidden = true
            self.viewLocationButtons.isHidden = true
            print("ViewAddressOuter ", #function)
            invoice.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-invoice.frame.height), size: CGSize(width: self.view.frame.width, height: invoice.frame.height))
            invoiceView = invoice
            self.invoiceView?.set(request: request)
            self.view.addSubview(invoiceView!)
            invoiceView?.show(with: .bottom, completion: nil)
        }
        self.invoiceView?.onClickPaynow = {
            print("Called",#function)
            self.loader.isHidden = false
            let requestObj = Request()
            requestObj.request_id = request.id
            self.presenter?.post(api: .payNow, data: requestObj.toData())
            
        }
        
    }
    
    
    // MARK:- Remove RideStatus View
    
    func removeInvoiceView() {
        self.buttonSOS.isHidden = true
        self.invoiceView?.dismissView(onCompletion: {
            self.invoiceView = nil
            riderStatus = .none
        })
    }
    
    
    // MARK:- Show RideStatus View
    
    func showRatingView(with request : Request) {
        
        guard self.ratingView == nil else { return }
        self.removeInvoiceView()
        if let rating = Bundle.main.loadNibNamed(XIB.Names.RatingView, owner: self, options: [:])?.first as? RatingView {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowRateView(info:)), name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideRateView(info:)), name: .UIKeyboardWillHide, object: nil)
            self.viewAddressOuter.isHidden = true
            self.viewLocationButtons.isHidden = true
            rating.frame = CGRect(origin: CGPoint(x: 0, y: self.view.frame.height-rating.frame.height), size: CGSize(width: self.view.frame.width, height: rating.frame.height))
            ratingView = rating
            self.view.addSubview(ratingView!)
            ratingView?.show(with: .bottom, completion: nil)
        }
        ratingView?.set(request: request)
        ratingView?.onclickRating = { (rating, comments) in
            if self.currentRequestId > 0 {
                var rate = Rate()
                rate.request_id = self.currentRequestId
                rate.rating = rating
                rate.comments = comments
                self.presenter?.post(api: .rateProvider, data: rate.toData())
            }
            self.removeRatingView()
        }
        
    }
    
    
    // MARK:- Remove RideStatus View
    
    func removeRatingView() {
        
        self.ratingView?.dismissView(onCompletion: {
            self.ratingView = nil
            self.viewAddressOuter.isHidden = false
            self.viewLocationButtons.isHidden = false
            self.clearMapview()
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        })
    }
    
    //MARK:- Keyboard will show
    
    @IBAction func keyboardWillShowRateView(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
       self.ratingView?.frame.origin.y =  keyboard.origin.y-(self.ratingView?.frame.height ?? 0 )
    }
    
    
    //MARK:- Keyboard will hide
    
    @IBAction func keyboardWillHideRateView(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
         self.ratingView?.frame.origin.y += keyboard.size.height
        
    }
    
    
    // MARK:- Show Providers In Current Location
    
    func showProviderInCurrentLocation(with data : [Service]) {
        
        self.markersProviders.forEach({ $0.map = nil })
        self.markersProviders.removeAll()
        
        for locationData in data where locationData.longitude != nil && locationData.latitude != nil {
            
            //            let lottieView = LottieView(name: "suv")
            //            lottieView.frame = CGRect(origin: .zero, size: CGSize(width: 50, height: 50))
            //            lottieView.loopAnimation = true;
            //            lottieView.play()
            
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(locationData.latitude!, locationData.longitude!))
            marker.icon = #imageLiteral(resourceName: "map-vehicle-icon-black").resizeImage(newWidth: 40)
            marker.groundAnchor = CGPoint(x: 0.5, y: 1)
            marker.map = mapViewHelper?.mapView
            self.markersProviders.append(marker)
            
        }
        
    }
    
    // MARK:- Show Loader View
    
    func showLoaderView(with requestId : Int? = nil) {
        
        if self.requestLoaderView == nil, let singleView = Bundle.main.loadNibNamed(XIB.Names.LoaderView, owner: self, options: [:])?.first as? LoaderView {
            self.isOnBooking = true
            singleView.frame = self.viewMapOuter.bounds
            self.requestLoaderView = singleView
            self.requestLoaderView?.onCancel = {
                self.cancelCurrentRide()
            }
            self.view.addSubview(singleView)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { // Hiding Address View
                UIView.animate(withDuration: 0.5, animations: {
                    self.viewAddressOuter.isHidden = false
                    self.viewLocationButtons.isHidden = true
                    print("ViewAddressOuter ", #function)
                })
            }
        }
        self.requestLoaderView?.isCancelButtonEnabled = requestId != nil
    }
    
    // MARK:- Remove Loader View
    
    func removeLoaderView() {
        
        self.requestLoaderView?.endLoader {
            self.requestLoaderView = nil
            self.viewAddressOuter.isHidden = false
            self.viewLocationButtons.isHidden = false
            print("ViewAddressOuter ", #function)
        }
    }
    
    // MARK:- Show Cancel Reason View
    
    private func showCancelReasonView(completion : @escaping ((String)->Void)) {
        
        if self.reasonView == nil, let reasonView = Bundle.main.loadNibNamed(XIB.Names.ReasonView, owner: self, options: [:])?.first as? ReasonView {
            reasonView.frame = CGRect(x: 16, y: 50, width: self.view.frame.width-32, height: reasonView.frame.height)
            self.reasonView = reasonView
            self.reasonView?.didSelectReason = { cancelReason in
               completion(cancelReason)
            }
            self.view.addSubview(reasonView)
            self.reasonView?.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
            UIView.animate(withDuration: 1.0,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.2),
                           initialSpringVelocity: CGFloat(2.0),
                           options: .allowUserInteraction,
                           animations: {
                           self.reasonView?.transform = .identity },
                           completion: { Void in()  })
        }
        
    }
    
    // MARK:- Remove Cancel View
    
    private func removeCancelView() {
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.reasonView?.transform = CGAffineTransform(scaleX: 0.0000001, y: 0000001)
                       }) { (_) in
                        self.reasonView?.removeFromSuperview()
                        self.reasonView = nil
                       }
        
        /*(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.2),
                       initialSpringVelocity: CGFloat(2.0),
                       options: .allowUserInteraction,
                       animations: {
                        self.reasonView?.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                        },
                       completion: { Void in()
                        self.reasonView?.removeFromSuperview()
                        self.reasonView = nil
                       }) */
    }
    
    
    
    // MARK:- Clear Map View
    
    func clearMapview() {
        
        self.mapViewHelper?.mapView?.clear()
        self.destinationLocationDetail = nil
        self.viewAddressOuter.isHidden = false
        self.viewLocationButtons.isHidden = false
    }
    
    // MARK:- Handle Request Data
    
    func handle(request : Request) {
        
        guard let status = request.status, request.id != nil else { return }
        
        DispatchQueue.global(qos: .default).async {
            
            self.currentRequestId = request.id!
            if let dAddress = request.d_address, let dLatitude = request.d_latitude, let dLongitude = request.d_longitude {
                self.destinationLocationDetail = LocationDetail(dAddress, LocationCoordinate(latitude: dLatitude, longitude: dLongitude))
                DispatchQueue.main.async {
                    self.drawPolyline()
                }
            }
            
        }
        
        switch status{
            
        case .searching:
            self.showLoaderView(with: self.currentRequestId)
            
        case .accepted, .arrived, .started, .pickedup:
            self.showRideStatusView(with: request)
            
        case .dropped:
            self.showInvoiceView(with: request)
            riderStatus = .none
        case .completed:
            riderStatus = .none
            if request.paid == true.hashValue {
                self.showRatingView(with: request)
            } else {
                self.showInvoiceView(with: request)
            }
        default:
            break
        }
        
        self.removeUnnecessaryView(with: status)
        
    }
    
    // MARK:- Remove Other Views
    
    func removeUnnecessaryView(with status : RideStatus) {
        
        if ![RideStatus.searching].contains(status) {
            self.removeLoaderView()
            self.removeRideNow()
        }
        if ![RideStatus.started, .accepted, .arrived, .pickedup].contains(status) {
            self.removeRideStatusView()
        }
        if ![RideStatus.completed].contains(status) {
            self.removeRatingView()
        }
        if ![RideStatus.dropped, .completed].contains(status) {
            self.removeInvoiceView()
        }
        if [RideStatus.none, .cancelled].contains(status) {
            self.currentRequestId = 0 // Remove Current Request
        }
        
    }
    
    
    // MARK:- Share Ride
    func shareRide() {
        if let currentLocation  = currentLocation.value {
            
            let format = "http://maps.google.com/maps?q=loc:\(currentLocation.latitude),\(currentLocation.longitude)"
            let  message = "\(AppName) :- \(String.removeNil(User.main.firstName)) \(String.removeNil(User.main.lastName)) \(Constants.string.wouldLikeToShare) \(format)"
            self.share(items: [#imageLiteral(resourceName: "Splash_icon"), message])
        }
    }
    
    
    // MARK:- Share Items
    
    func share(items : [Any]) {
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    // MARK:- Cancel Current Ride
    
    private func cancelCurrentRide(isSendReason : Bool = false) {
        
        let alert = PopupDialog(title: Constants.string.cancelRequest.localize(), message: Constants.string.cancelRequestDescription.localize())
        let cancelButton =  PopupDialogButton(title: Constants.string.no.localize(), action: {
            alert.dismiss()
        })
        cancelButton.titleColor = .primary
        let sureButton = PopupDialogButton(title: Constants.string.yes.localize()) {
            if isSendReason {
                self.showCancelReasonView(completion: { (reason) in  // Getting Cancellation Reason After Providing Accepting Ride
                    cancelRide(reason: reason)
                    self.removeCancelView()
                })
            } else {
                 cancelRide()
            }
        }
        sureButton.titleColor = .red
        alert.addButtons([cancelButton,sureButton])
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
        
        func cancelRide(reason : String? = nil) { // Cancel Ride
            self.loader.isHidden = false
            self.cancelRequest(reason: reason)
            self.removeLoaderView()
            self.clearMapview()
            self.removeRideNow()
            self.isOnBooking = false
        }
        
        
    }
    
    // MARK:- SOS Action
    
    @IBAction func buttonSOSAction() {
        
        showAlert(message: Constants.string.wouldyouLiketoMakeaSOSCall.localize(), okHandler: {
            Common.call(to: "\(User.main.sos ?? "911")")
        }, cancelHandler: {
            
        }, fromView: self)
        
    }
    
    // MARK:- Provider Location Marker
    
    func moveProviderMarker(to location : LocationCoordinate) {
        
        if markerProviderLocation.map == nil {
            markerProviderLocation.map = mapViewHelper?.mapView
        }
        let originCoordinate = CGPoint(x: providerLastLocation.latitude-location.latitude, y: providerLastLocation.longitude-location.longitude)
        let tanDegree = atan2(originCoordinate.x, originCoordinate.y)
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        markerProviderLocation.position = location
        markerProviderLocation.rotation = CLLocationDegrees(tanDegree*CGFloat.pi/180)
        CATransaction.commit()
        self.providerLastLocation = location
    }
    
    // MARK:- Add Floating Button
    
    private func addFloatingButton(with padding : CGFloat, to provider : Provider?) {
        
        if provider != nil {
            let floaty = Floaty()
            floaty.plusColor = .primary
            floaty.hasShadow = false
            floaty.autoCloseOnTap = true
            floaty.buttonColor = .white
            floaty.buttonImage = #imageLiteral(resourceName: "phoneCall").withRenderingMode(.alwaysTemplate).resizeImage(newWidth: 25)
            floaty.paddingY = padding
            floaty.itemImageColor = .secondary
            floaty.addItem(icon: #imageLiteral(resourceName: "call").resizeImage(newWidth: 25)) { (_) in
                Common.call(to: provider!.mobile)
            }
            floaty.addItem(icon: #imageLiteral(resourceName: "chatIcon").resizeImage(newWidth: 25)) { (_) in
                print("Chat ")
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SingleChatController) as? SingleChatController {
                    vc.set(user: provider!)
                    let navigation = UINavigationController(rootViewController: vc)
                    self.present(navigation, animated: true, completion: nil)
                }
            }
            self.floatyButton = floaty
            self.viewMapOuter.addSubview(floaty)
        }
    }
    
    
}

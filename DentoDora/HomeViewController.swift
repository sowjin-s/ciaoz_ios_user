//
//  HomeViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import KWDrawerController
import GoogleMaps

class HomeViewController: UIViewController {
    
    @IBOutlet private var viewSideMenu : UIView!
    @IBOutlet private var viewCurrentLocation : UIView!
    @IBOutlet weak private var viewMapOuter : UIView!
    @IBOutlet weak private var viewFavouriteSource : UIView!
    @IBOutlet weak private var viewFavouriteDestination : UIView!
    @IBOutlet weak private var viewSourceLocation : UIView!
    @IBOutlet weak private var viewDestinationLocation : UIView!
    @IBOutlet weak private var viewAddress : UIView!
    @IBOutlet weak private var textFieldSourceLocation : UITextField!
    @IBOutlet weak private var textFieldDestinationLocation : UITextField!
    
    private let transition = CircularTransition()  // Translation to for location Tap
    private var mapViewHelper : GoogleMapsHelper?
    private var favouriteViewSource : LottieView?
    private var favouriteViewDestination : LottieView?
    
    private var isSourceFavourited = false {  // Boolean to handle favourite source location
        didSet{
            self.isAddLottie(view: &favouriteViewSource, in: viewFavouriteSource, isAdd: !isSourceFavourited)
        }
    }

    private var isDestinationFavourited = false { // Boolean to handle favourite destination location
        didSet{
            self.isAddLottie(view: &favouriteViewDestination, in: viewFavouriteDestination, isAdd: !isDestinationFavourited)
        }
    }
    
    
    private var sourceLocationDetail : LocationDetail? {  // Source Location Detail
        didSet{
             self.textFieldSourceLocation.text = sourceLocationDetail?.address
        }
    }
    
    private var destinationLocationDetail : LocationDetail? {  // Destination Location Detail
        didSet{
            self.textFieldDestinationLocation.text = destinationLocationDetail?.address
        }
    }
    
    private var currentLocation : Bind<LocationCoordinate>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewCurrentLocation.makeRoundedCorner()
    }

}

// MARK:- Methods

extension HomeViewController {
    
    private func initialLoads(){
        
        self.addMapView()
        self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
        self.navigationController?.isNavigationBarHidden = true
        self.viewFavouriteDestination.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
        self.viewFavouriteSource.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
        self.viewSourceLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationTapAction(sender:))))
        self.viewDestinationLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationTapAction(sender:))))
        self.currentLocation?.bind(listener: { (locationCoordinate) in
            // TODO:- Handle Current Location
            if locationCoordinate != nil {
                self.mapViewHelper?.moveTo(location: locationCoordinate!)
            }
        })
        
    }
    
    // MARK:- Localize
    
    private func localize(){
        
        self.textFieldSourceLocation.placeholder = Constants.string.source.localize()
        self.textFieldDestinationLocation.placeholder = Constants.string.destination.localize()
        
    }
    
    // MARK:- Add Mapview
    
    private func addMapView(){
        
        self.mapViewHelper = GoogleMapsHelper()
        self.mapViewHelper?.getMapView(in: self.viewMapOuter)
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
            self.currentLocation?.value = location
        })
        
    }
    
    
    // MARK:- Favourite Location Action
    
    @IBAction private func favouriteLocationAction(sender : UITapGestureRecognizer) {
        
        guard let senderView = sender.view else { return }
        
        if senderView == viewFavouriteDestination {
            self.isSourceFavourited = !self.isSourceFavourited
        } else {
            self.isDestinationFavourited = !self.isDestinationFavourited
        }
    }
    
    // MARK:- Favourite Location Action
    
    @IBAction private func locationTapAction(sender : UITapGestureRecognizer) {
        
        guard let senderView = sender.view else { return }
        
        if let locationView = Bundle.main.loadNibNamed("LocationSelectionView", owner: self, options: [:])?.first as? LocationSelectionView {
            locationView.frame = self.view.bounds
            self.view.addSubview(locationView)
            locationView.backButton { (locationDetail) in
                if senderView == self.viewSourceLocation{
                    self.sourceLocationDetail = locationDetail
                } else {
                    self.destinationLocationDetail = locationDetail
                }
                
            }
        }
        
        
    }
    
    // MARK:- SideMenu Button Action
    
   @IBAction private func sideMenuAction(){
        
        self.drawerController?.openSide(.left)
        
    }
    
    // MARK:- Add or remove lottie View
    
    private func isAddLottie(view lottieView : inout LottieView?,in viewToBeAdded : UIView, isAdd : Bool){
        
        if isAdd {
            let frame =  view.bounds//CGRect(x: viewToBeAdded.frame.maxX/2, y: viewToBeAdded.frame.maxY/2, width: viewToBeAdded.frame.width/2, height: viewToBeAdded.frame.height/2)
            lottieView = LottieHelper().addHeart(with: frame)
            view.addSubview(lottieView!)
            lottieView?.play()
        } else {
            let lottie = lottieView // inout parameter cannot be captured by escaping key
            UIView.animate(withDuration: 0.2, animations: {
                lottie?.alpha = 0
            }) { (_) in
                lottie?.removeFromSuperview()
            }
        }
        
    }
    
}


// MARK:- MapView

extension HomeViewController : GMSMapViewDelegate {
    
    
    
}

// MARK:-  UIViewControllerTransitioningDelegate

extension HomeViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      
        if type(of: presented) == LocationSelectionViewController.self {
            
            transition.transitionMode = .present
            transition.startingPoint = viewSourceLocation.center
            transition.circleColor = .clear
            return transition
        }
        return nil
        
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       
        if type(of: dismissed) == LocationSelectionViewController.self {
            
            transition.transitionMode = .dismiss
            transition.startingPoint = viewSourceLocation.center
            transition.circleColor = .clear
            return transition
        }
        return nil
    }
    
}




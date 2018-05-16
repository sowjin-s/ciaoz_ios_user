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
import GooglePlaces

class HomeViewController: UIViewController {
    
    @IBOutlet private var viewSideMenu : UIView!
    @IBOutlet private var viewCurrentLocation : UIView!
    @IBOutlet weak private var viewMapOuter : UIView!
    @IBOutlet weak private var viewFavouriteSource : UIView!
    @IBOutlet weak private var viewFavouriteDestination : UIView!
    @IBOutlet weak private var viewSourceLocation : UIView!
    @IBOutlet weak private var viewDestinationLocation : UIView!
    @IBOutlet weak private var viewAddress : UIView!
    @IBOutlet weak private var viewAddressOuter : UIView!
    @IBOutlet weak private var textFieldSourceLocation : UITextField!
    @IBOutlet weak private var textFieldDestinationLocation : UITextField!
    @IBOutlet weak private var imageViewMarkerCenter : UIImageView!
    
    private var selectedLocationView = UIView() // View to change the location pinpoint
    
    private var isUserInteractingWithMap = false // Boolean to handle Mapview User interaction
    
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
    
    
    private var sourceLocationDetail : Bind<LocationDetail>? = Bind<LocationDetail>(nil) {  // Source Location Detail
        didSet{
            DispatchQueue.main.async {
                 self.textFieldSourceLocation.text = self.sourceLocationDetail?.value?.address
            }
        }
    }
    
    private var destinationLocationDetail : LocationDetail? {  // Destination Location Detail
        didSet{
            DispatchQueue.main.async {
                self.textFieldDestinationLocation.text = self.destinationLocationDetail?.address
            }
        }
    }
    
    private var favouriteLocations = [(String, LocationDetail?)]() // Favourite Locations of User
    
    private var currentLocation = Bind<LocationCoordinate>(defaultMapLocation)
    
    
    //MARKERS
    
    private var sourceMarker = GMSMarker()
    private var destinationMarker = GMSMarker()

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
        self.getFavouriteLocations()
        self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
        self.navigationController?.isNavigationBarHidden = true
        self.viewFavouriteDestination.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
        self.viewFavouriteSource.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
        self.viewSourceLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationTapAction(sender:))))
        self.viewDestinationLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationTapAction(sender:))))
        self.currentLocation.bind(listener: { (locationCoordinate) in
            // TODO:- Handle Current Location
            if locationCoordinate != nil {
                self.mapViewHelper?.moveTo(location: locationCoordinate!, with: self.viewMapOuter.center)
            }
        })
        self.viewCurrentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getCurrentLocation)))
    }
    
    @IBAction private func getCurrentLocation(){
        
        if currentLocation.value != nil {
            self.mapViewHelper?.moveTo(location: currentLocation.value!, with: self.viewMapOuter.center)
        }
    }
    
    
    // MARK:- Localize
    
    private func localize(){
        
        self.textFieldSourceLocation.placeholder = Constants.string.source.localize()
        self.textFieldDestinationLocation.placeholder = Constants.string.destination.localize()
        
    }
    
    // MARK:- Add Mapview
    
    private func addMapView(){
        
        self.mapViewHelper = GoogleMapsHelper()
        self.mapViewHelper?.getMapView(withDelegate: self, in: self.viewMapOuter)
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
            self.currentLocation.value = location
        })
        
        self.sourceMarker.icon = #imageLiteral(resourceName: "destinationPin").resizeImage(newWidth: 30)
        self.destinationMarker.icon = #imageLiteral(resourceName: "sourcePin").resizeImage(newWidth: 30)
        
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
        self.selectedLocationView.transform = CGAffineTransform.identity
        
        if self.selectedLocationView == senderView {
           self.showLocationView()
        } else {
           self.selectedLocationView = senderView
           self.selectionViewAction(in: senderView)
        }
        self.selectedLocationView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        self.viewAddress.bringSubview(toFront: self.selectedLocationView)
       // self.showLocationView()
    }
    
    
    // MARK:- Show Marker on Location
    
    private func selectionViewAction(in currentSelectionView : UIView){
        
        if currentSelectionView == self.viewSourceLocation {
            
            if let coordinate = self.sourceLocationDetail?.value?.coordinate{
                self.plotMarker(marker: sourceMarker, with: coordinate)
            } else {
                self.showLocationView()
            }
        } else if currentSelectionView == self.viewDestinationLocation {
            
            if let coordinate = self.destinationLocationDetail?.coordinate{
                self.plotMarker(marker: destinationMarker, with: coordinate)
            } else {
                self.showLocationView()
            }
        }
        
    }
    
    private func plotMarker(marker : GMSMarker, with coordinate : CLLocationCoordinate2D){
        
        marker.position = coordinate
        marker.appearAnimation = .pop
        marker.map = self.mapViewHelper?.mapView
        marker.map?.center = viewMapOuter.center
        self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
        
    }
    
    
    // MARK:- Show Location View
    
    private func showLocationView() {
        
        if let locationView = Bundle.main.loadNibNamed(XIB.Names.LocationSelectionView, owner: self, options: [:])?.first as? LocationSelectionView {
            locationView.frame = self.view.bounds
            locationView.setValues(address: (sourceLocationDetail,destinationLocationDetail), favourites: self.favouriteLocations) { (address) in
                
                self.sourceLocationDetail = address.source
                self.destinationLocationDetail = address.destination
                
               /* if let sourceCoordinate = self.sourceLocationDetail?.value?.coordinate, let destinationCoordinate = self.destinationLocationDetail?.coordinate {  // Draw polyline from source to destination
                    self.mapViewHelper?.mapView?.drawPolygon(from: sourceCoordinate, to: destinationCoordinate)
                }*/
            }
            self.view.addSubview(locationView)
            
            self.selectedLocationView.transform = .identity
            self.selectedLocationView = UIView()
        }
        
    }
    
    
    // MARK:- Send Request
    
    private func sendRequest(){
        
        if self.destinationLocationDetail != nil {
            
            
        }
        
    }
    
    
    
    // MARK:- Get Favourite Locations
    
    private func getFavouriteLocations(){
        
        self.favouriteLocations.append((Constants.string.home,nil))
        self.favouriteLocations.append((Constants.string.work,nil))
        
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
    
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        print("Gesture ",gesture)
        self.isUserInteractingWithMap = gesture
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        print(#function)
        
        if isUserInteractingWithMap {
            
            if self.selectedLocationView == self.viewSourceLocation {
                self.sourceMarker.map = nil
                self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "destinationPin")
                self.imageViewMarkerCenter.isHidden = false
                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                        print(locationDetail)
                        self.sourceLocationDetail?.value = locationDetail
                        let sLocation = self.sourceLocationDetail
                        self.sourceLocationDetail = sLocation
                    })
                }
                
                
            } else if self.selectedLocationView == self.viewDestinationLocation {
                self.destinationMarker.map = nil
                self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "sourcePin")
                self.imageViewMarkerCenter.isHidden = false
                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                        print(locationDetail)
                        self.destinationLocationDetail = locationDetail
                    })
                }
            }
            
        } else {
            self.destinationMarker.map = self.mapViewHelper?.mapView
            self.sourceMarker.map = self.mapViewHelper?.mapView
            self.imageViewMarkerCenter.isHidden = true
        }
        
    }
    
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




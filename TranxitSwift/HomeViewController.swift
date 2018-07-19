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
    import DateTimePicker
    //import IQKeyboardManagerSwift
    
    class HomeViewController: UIViewController {
        
        @IBOutlet private var viewSideMenu : UIView!
        @IBOutlet private var viewCurrentLocation : UIView!
        @IBOutlet weak var viewMapOuter : UIView!
        @IBOutlet weak private var viewFavouriteSource : UIView!
        @IBOutlet weak private var viewFavouriteDestination : UIView!
        @IBOutlet weak private var imageViewFavouriteSource : ImageView!
        @IBOutlet weak private var imageViewFavouriteDestination : ImageView!
        @IBOutlet weak private var viewSourceLocation : UIView!
        @IBOutlet weak private var viewDestinationLocation : UIView!
        @IBOutlet weak private var viewAddress : UIView!
        @IBOutlet weak var viewAddressOuter : UIView!
        @IBOutlet weak private var textFieldSourceLocation : UITextField!
        @IBOutlet weak private var textFieldDestinationLocation : UITextField!
        @IBOutlet weak private var imageViewMarkerCenter : UIImageView!
        @IBOutlet weak private var imageViewSideBar : UIImageView!
        @IBOutlet weak var buttonSOS : UIButton!
        @IBOutlet weak private var viewHomeLocation : UIView!
        @IBOutlet weak private var viewWorkLocation : UIView!
        @IBOutlet weak var viewLocationButtons : UIStackView!
        
        @IBOutlet var constraint : NSLayoutConstraint!
        
        var providerLastLocation = LocationCoordinate()
        lazy var markerProviderLocation : GMSMarker = {  // Provider Location Marker
            
            let marker = GMSMarker()
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
            imageView.contentMode =  .scaleAspectFit
            imageView.image = #imageLiteral(resourceName: "map-vehicle-icon-black")
            marker.iconView = imageView
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = self.mapViewHelper?.mapView
            return marker
            
        }()
        
        private var selectedLocationView = UIView() // View to change the location pinpoint
        {
            didSet{
                if !([viewSourceLocation, viewDestinationLocation].contains(selectedLocationView)) {
                    [viewSourceLocation, viewDestinationLocation].forEach({ $0?.transform = .identity })
                }
            }
        }
        
        var isOnBooking = false {  // Boolean to handle back using side menu button
            didSet {
                self.imageViewSideBar.image = isOnBooking ? #imageLiteral(resourceName: "back-icon") : #imageLiteral(resourceName: "menu_icon")
            }
        }
        
        private var isUserInteractingWithMap = false // Boolean to handle Mapview User interaction
        private var riderStatus : RideStatus = .none // Provider Current Status
        // private let transition = CircularTransition()  // Translation to for location Tap
        var mapViewHelper : GoogleMapsHelper?
//        private var favouriteViewSource : LottieView?
//        private var favouriteViewDestination : LottieView?
        
        private var isSourceFavourited = false {  // Boolean to handle favourite source location
            didSet{
                self.isAddFavouriteLocation(in: self.viewFavouriteSource, isAdd: isSourceFavourited)
            }
        }
        
        private var isDestinationFavourited = false { // Boolean to handle favourite destination location
            didSet{
                self.isAddFavouriteLocation(in: self.viewFavouriteDestination, isAdd: isDestinationFavourited)
            }
        }
        
        
        var sourceLocationDetail : Bind<LocationDetail>? = Bind<LocationDetail>(nil)
        
        var destinationLocationDetail : LocationDetail? {  // Destination Location Detail
            didSet{
                DispatchQueue.main.async {
                    self.isDestinationFavourited = false // reset favourite location on change
                    if self.destinationLocationDetail == nil {
                        self.isDestinationFavourited = false
                    }
                    self.textFieldDestinationLocation.text = (self.destinationLocationDetail?.address.removingWhitespaces().isEmpty ?? true) ? nil : self.destinationLocationDetail?.address
                }
            }
        }
        
        //  private var favouriteLocations : LocationService? //[(type : String,address: [LocationDetail])]() // Favourite Locations of User
        
        var currentLocation = Bind<LocationCoordinate>(defaultMapLocation)
        
        //var serviceSelectionView : ServiceSelectionView?
        // var rideSelectionView : RequestSelectionView?
        var locationSelectionView : LocationSelectionView?
        var requestLoaderView : LoaderView?
        var rideStatusView : RideStatusView? {
            didSet {
                if self.rideStatusView == nil {
                    self.floatyButton?.removeFromSuperview()
                }
            }
        }
        var invoiceView : InvoiceView?
        var ratingView : RatingView?
        var rideNowView : RideNowView?
        var floatyButton : Floaty?
        
        lazy var loader  : UIView = {
            return createActivityIndicator(self.view)
        }()
        
        var currentRequestId = 0
        
        //MARKERS
        
        private var sourceMarker : GMSMarker = {
            let marker = GMSMarker()
            marker.appearAnimation = .pop
            marker.icon =  #imageLiteral(resourceName: "sourcePin").resizeImage(newWidth: 30)
            return marker
        }()
        
        private var destinationMarker : GMSMarker = {
            let marker = GMSMarker()
            marker.appearAnimation = .pop
            marker.icon =  #imageLiteral(resourceName: "destinationPin").resizeImage(newWidth: 30)
            return marker
        }()
        
        var markersProviders = [GMSMarker]()
        
        var homePageHelper : HomePageHelper?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.initialLoads()
            self.localize()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.navigationController?.isNavigationBarHidden = true
            self.localize()
            //IQKeyboardManager.shared.enable = true
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            self.viewLayouts()
        }
        
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            //IQKeyboardManager.shared.enable = false
//        }
        
        
        //    var tempLat = 13.05864944
        //    var tempLong = 80.25398977
        
    }
    
    // MARK:- Methods
    
    extension HomeViewController {
        
        private func initialLoads(){
            
            self.addMapView()
            self.getFavouriteLocationsFromLocal()
            self.getFavouriteLocations()
            self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
            self.navigationController?.isNavigationBarHidden = true
            self.viewFavouriteDestination.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
            self.viewFavouriteSource.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
            [self.viewSourceLocation, self.viewDestinationLocation].forEach({ $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationTapAction(sender:))))})
            [self.viewHomeLocation, self.viewWorkLocation].forEach({ $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewLocationButtonAction(sender:))))})
            self.currentLocation.bind(listener: { (locationCoordinate) in
                // TODO:- Handle Current Location
                if locationCoordinate != nil {
                    self.mapViewHelper?.moveTo(location: locationCoordinate!, with: self.viewMapOuter.center)
                }
            })
            self.viewCurrentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getCurrentLocation)))
            self.sourceLocationDetail?.bind(listener: { (locationDetail) in
                if locationDetail == nil {
                    self.isSourceFavourited = false
                }
                DispatchQueue.main.async {
                    self.isSourceFavourited = false // reset favourite location on change
//                    if self.sourceLocationDetail?.value != nil, self.destinationLocationDetail != nil { // Get Services only if location Available
//                        self.getServicesList()
//                    }
                    self.textFieldSourceLocation.text = locationDetail?.address
                }
            })
            self.viewDestinationLocation.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.checkForProviderStatus()
            self.buttonSOS.isHidden = true
            self.buttonSOS.addTarget(self, action: #selector(self.buttonSOSAction), for: .touchUpInside)
            self.setDesign()
            NotificationCenter.default.addObserver(self, selector: #selector(self.observer(notification:)), name: .providers, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowRateView(info:)), name: .UIKeyboardWillShow, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideRateView(info:)), name: .UIKeyboardWillHide, object: nil)      }
        }
        
        // MARK:- View Will Layouts
        
        private func viewLayouts() {
            
            self.viewCurrentLocation.makeRoundedCorner()
            self.mapViewHelper?.mapView?.frame = viewMapOuter.bounds
            self.viewSideMenu.makeRoundedCorner()
            self.navigationController?.isNavigationBarHidden = true            
        }
        
        @IBAction private func getCurrentLocation(){
            
            self.viewCurrentLocation.addPressAnimation()
            if currentLocation.value != nil {
                self.mapViewHelper?.getPlaceAddress(from: currentLocation.value!, on: { (locationDetail) in  // On Tapping current location, set
                    if self.selectedLocationView == self.viewSourceLocation {
                        self.sourceLocationDetail?.value = locationDetail
                    } else if self.selectedLocationView == self.viewDestinationLocation {
                        self.destinationLocationDetail = locationDetail
                    }
                })
                self.mapViewHelper?.moveTo(location: self.currentLocation.value!, with: self.viewMapOuter.center)
            }
        }
        
        
        // MARK:- Localize
        
        private func localize(){
            
            self.textFieldSourceLocation.placeholder = Constants.string.source.localize()
            self.textFieldDestinationLocation.placeholder = Constants.string.destination.localize()
            
        }
        
        // MARK:- Set Design
        
        private func setDesign() {
            
            Common.setFont(to: textFieldSourceLocation)
            Common.setFont(to: textFieldDestinationLocation)
        }
        
        // MARK:- Add Mapview
        
        private func addMapView(){
            
            self.mapViewHelper = GoogleMapsHelper()
            self.mapViewHelper?.getMapView(withDelegate: self, in: self.viewMapOuter)
            self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
                if self.sourceLocationDetail?.value == nil {
                    self.mapViewHelper?.getPlaceAddress(from: location.coordinate, on: { (locationDetail) in
                        self.sourceLocationDetail?.value = locationDetail
                    })
                }
                self.currentLocation.value = location.coordinate
            })
            
        }
        
        // MARK:- Observer
        
       @objc private func observer(notification : Notification) {
            
            if notification.name == .providers, let serviceArray = notification.userInfo?[Notification.Name.providers.rawValue] as? [Service] {
                showProviderInCurrentLocation(with: serviceArray)
                
            }
            
        }
        
        
        // MARK:- Get Favourite Location From Local
        
        private func getFavouriteLocationsFromLocal() {
            
            let favouriteLocationFromLocal = CoreDataHelper().favouriteLocations()
            
            for location in favouriteLocationFromLocal
            {
                switch location.key {
                    case CoreDataEntity.home.rawValue where location.value is Work:
                        if let workObject = location.value as? Work, let address = workObject.address {
                            favouriteLocations.append((location.key, (address, LocationCoordinate(latitude: workObject.latitude, longitude: workObject.longitude))))
                        }
                   case CoreDataEntity.home.rawValue where location.value is Work:
                        if let homeObject = location.value as? Home, let address = homeObject.address {
                            favouriteLocations.append((location.key, (address, LocationCoordinate(latitude: homeObject.latitude, longitude: homeObject.longitude))))
                        }
                default:
                    break
                    
                }
                
                
            }
            
        }
        
        // MARK:- View Location Action
        
        @IBAction private func viewLocationButtonAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view else { return }
            if senderView == viewHomeLocation, let location = CoreDataHelper().favouriteLocations()[CoreDataEntity.home.rawValue] as? Home, let addressString = location.address {
                self.destinationLocationDetail = (addressString, LocationCoordinate(latitude: location.latitude, longitude: location.longitude))
            } else if senderView == viewWorkLocation, let location = CoreDataHelper().favouriteLocations()[CoreDataEntity.work.rawValue] as? Work, let addressString = location.address {
                self.destinationLocationDetail = (addressString, LocationCoordinate(latitude: location.latitude, longitude: location.longitude))
            }
            
            if destinationLocationDetail == nil { // No Previous Location Avaliable
                self.showLocationView()
            } else {
                self.drawPolyline() // Draw polyline between source and destination
                self.getServicesList() // get Services
            }
            
        }
        
        
        // MARK:- Favourite Location Action
        
        @IBAction private func favouriteLocationAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view else { return }
            senderView.addPressAnimation()
            if senderView == viewFavouriteSource {
                self.isSourceFavourited = self.sourceLocationDetail?.value != nil ? !self.isSourceFavourited : false
            } else if senderView == viewFavouriteDestination {
                self.isDestinationFavourited = self.destinationLocationDetail != nil ? !self.isDestinationFavourited : false
            }
        }
        
        // MARK:- Favourite Location Action
        
        private func isAddFavouriteLocation(in viewFavourite : UIView, isAdd : Bool) {
            
            if viewFavourite == viewFavouriteSource {
                self.imageViewFavouriteSource.image = (isAdd ? #imageLiteral(resourceName: "like") : #imageLiteral(resourceName: "unlike")).withRenderingMode(.alwaysTemplate)
            } else {
                self.imageViewFavouriteDestination.image = (isAdd ? #imageLiteral(resourceName: "like") : #imageLiteral(resourceName: "unlike")).withRenderingMode(.alwaysTemplate)
            }
            self.favouriteLocationApi(in: viewFavourite, isAdd: isAdd) // Send to Api Call

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
                    self.plotMarker(marker: &sourceMarker, with: coordinate)
                    print("Source Marker - ", coordinate.latitude, " ",coordinate.longitude)
                } else {
                    self.showLocationView()
                }
            } else if currentSelectionView == self.viewDestinationLocation {
                
                if let coordinate = self.destinationLocationDetail?.coordinate{
                    self.plotMarker( marker: &destinationMarker, with: coordinate)
                    print("Destination Marker - ", coordinate.latitude, " ",coordinate.longitude)
                } else {
                    self.showLocationView()
                }
            }
            
        }
        
        private func plotMarker(marker : inout GMSMarker, with coordinate : CLLocationCoordinate2D){
            
            //print("marker : \(marker == self.sourceMarker)")
            
            marker.position = coordinate
            //        marker.appearAnimation = .pop
            //        marker.icon = isSource ? #imageLiteral(resourceName: "sourcePin").resizeImage(newWidth: 30) : #imageLiteral(resourceName: "destinationPin").resizeImage(newWidth: 30)
            marker.map = self.mapViewHelper?.mapView
            //marker.map?.center = viewMapOuter.center
            self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
        }
        
        
        // MARK:- Show Location View
        
        @IBAction private func showLocationView() {
            
            if let locationView = Bundle.main.loadNibNamed(XIB.Names.LocationSelectionView, owner: self, options: [:])?.first as? LocationSelectionView {
                locationView.frame = self.view.bounds
                locationView.setValues(address: (sourceLocationDetail,destinationLocationDetail)) { (address) in
                    
                    self.removeUnnecessaryView(with: .none) // Remove services or ride now if previously open
                    self.sourceLocationDetail = address.source
                    self.destinationLocationDetail = address.destination
                    self.drawPolyline() // Draw polyline between source and destination
                    self.getServicesList() // get Services
                }
                self.view.addSubview(locationView)
                if selectedLocationView == self.viewSourceLocation {
                    locationView.textFieldSource.becomeFirstResponder()
                } else {
                    locationView.textFieldDestination.becomeFirstResponder()
                }
                self.selectedLocationView.transform = .identity
                self.selectedLocationView = UIView()
                self.locationSelectionView = locationView
            }
            
        }
        
        // MARK:- Remove Location VIew
        
        func removeLocationView() {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.locationSelectionView?.tableViewBottom.frame.origin.y = (self.locationSelectionView?.tableViewBottom.frame.height) ?? 0
                self.locationSelectionView?.viewTop.frame.origin.y = -(self.locationSelectionView?.viewTop.frame.height ?? 0)
            }) { (_) in
                self.locationSelectionView?.isHidden = true
                self.locationSelectionView?.removeFromSuperview()
                self.locationSelectionView = nil
            }
            
        }
        
        
        //MARK:- Draw Polyline
        
        func drawPolyline() {
            
            self.imageViewMarkerCenter.isHidden = true
            if let sourceCoordinate = self.sourceLocationDetail?.value?.coordinate,
                let destinationCoordinate = self.destinationLocationDetail?.coordinate {  // Draw polyline from source to destination
                self.mapViewHelper?.mapView?.clear()
                self.sourceMarker.map = self.mapViewHelper?.mapView
                self.destinationMarker.map = self.mapViewHelper?.mapView
                self.sourceMarker.position = sourceCoordinate
                self.destinationMarker.position = destinationCoordinate
                //self.selectionViewAction(in: self.viewSourceLocation)
                //self.selectionViewAction(in: self.viewDestinationLocation)
                self.mapViewHelper?.mapView?.drawPolygon(from: sourceCoordinate, to: destinationCoordinate)
                self.selectedLocationView = UIView()
            }
            
        }
        
        // MARK:- Get Favourite Locations
        
        private func getFavouriteLocations(){
            
            favouriteLocations.append((Constants.string.home,nil))
            favouriteLocations.append((Constants.string.work,nil))
            self.presenter?.get(api: .locationService, parameters: nil)
            
        }
        
        
        
        
        // MARK:- SideMenu Button Action
        
        @IBAction private func sideMenuAction(){
            
            
            if self.isOnBooking {
                self.removeLoaderView()
                self.removeUnnecessaryView(with: .none)
                self.clearMapview()
                self.viewAddressOuter.isHidden = false
                self.viewLocationButtons.isHidden = false
                print("ViewAddressOuter ", #function)
            } else {
                self.drawerController?.openSide(.left)
                self.viewSideMenu.addPressAnimation()
            }
            
            // self.serviceView()
            // self.showRideNowView()
            // self.showRideStatusView()
            // self.showInvoiceView()
            //  self.showRatingView()
            
        }
        
//        // MARK:- Add or remove lottie View
//
//        private func isAddLottie(view lottieView : inout LottieView?,in viewToBeAdded : UIView, isAdd : Bool){
//
//            if isAdd {
//                let frame =  view.bounds//CGRect(x: viewToBeAdded.frame.maxX/2, y: viewToBeAdded.frame.maxY/2, width: viewToBeAdded.frame.width/2, height: viewToBeAdded.frame.height/2)
//                lottieView = LottieHelper().addLottie(with: frame)
//                lottieView =
//                viewToBeAdded.addSubview(lottieView!)
//                lottieView?.play()
//            } else {
//                let lottie = lottieView // inout parameter cannot be captured by escaping key
//                UIView.animate(withDuration: 0.2, animations: {
//                    lottie?.alpha = 0
//                }) { (_) in
//                    lottie?.removeFromSuperview()
//                }
//            }
//
//        }
        
        // MARK:- Show DateTimePicker
        
        func schedulePickerView(on completion : @escaping ((Date)->())){
            
            var dateComponents = DateComponents()
            dateComponents.day = 7
            let now = Date()
            let maximumDate = Calendar.current.date(byAdding: dateComponents, to: now)
            dateComponents.minute = 30
            dateComponents.day = nil
            let minimumDate = Calendar.current.date(byAdding: dateComponents, to: now)
            let datePicker = DateTimePicker.show(selected: nil, minimumDate: minimumDate, maximumDate: maximumDate, timeInterval: .default)
            datePicker.includeMonth = true
            datePicker.is12HourFormat = true
            datePicker.dateFormat = DateFormat.list.hhmmddMMMyyyy
            datePicker.highlightColor = .primary
            datePicker.doneBackgroundColor = .secondary
            datePicker.completionHandler = { date in
                completion(date)
                print(date)
                
            }
        }
        
    }
    
    
    // MARK:- MapView
    
    extension HomeViewController : GMSMapViewDelegate {
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            
            if self.isUserInteractingWithMap {
                
                if self.selectedLocationView == self.viewSourceLocation, self.sourceLocationDetail != nil {
                    
                    if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                        self.sourceLocationDetail?.value?.coordinate = location
                        self.drawPolyline()
                        self.getServicesList()
                        self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                            //print(locationDetail)
                            self.sourceLocationDetail?.value = locationDetail
                        })
                    }
                } else if self.selectedLocationView == self.viewDestinationLocation, self.destinationLocationDetail != nil {
                    
                    if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                        self.destinationLocationDetail?.coordinate = location
                        self.drawPolyline()
                        self.getServicesList()
                        self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                            //print(locationDetail)
                            self.destinationLocationDetail = locationDetail
                        })
                    }
                }
                
            }
            self.isMapInteracted(false)
            
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            
            print("Gesture ",gesture)
            self.isUserInteractingWithMap = gesture
            
            if self.isUserInteractingWithMap {
                self.isMapInteracted(true)
            }
            
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            
            // return
            
            if isUserInteractingWithMap {
                
                if self.selectedLocationView == self.viewSourceLocation, self.sourceLocationDetail != nil {
                    
                    self.sourceMarker.map = nil
                    self.imageViewMarkerCenter.tintColor = .secondary
                    self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "sourcePin").withRenderingMode(.alwaysTemplate)
                    self.imageViewMarkerCenter.isHidden = false
                    //                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    //                    self.sourceLocationDetail?.value?.coordinate = location
                    //                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                    //                        print(locationDetail)
                    //                        self.sourceLocationDetail?.value = locationDetail
                    ////                        let sLocation = self.sourceLocationDetail
                    ////                        self.sourceLocationDetail = sLocation
                    //                    })
                    //                }
                    
                    
                } else if self.selectedLocationView == self.viewDestinationLocation, self.destinationLocationDetail != nil {
                    
                    self.destinationMarker.map = nil
                    self.imageViewMarkerCenter.tintColor = .primary
                    self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "destinationPin").withRenderingMode(.alwaysTemplate)
                    self.imageViewMarkerCenter.isHidden = false
                    //                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    //                    self.destinationLocationDetail?.coordinate = location
                    //                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                    //                        print(locationDetail)
                    //                        self.destinationLocationDetail = locationDetail
                    //                    })
                    //                }
                }
                
            }
            //        else {
            //            self.destinationMarker.map = self.mapViewHelper?.mapView
            //            self.sourceMarker.map = self.mapViewHelper?.mapView
            //            self.imageViewMarkerCenter.isHidden = true
            //        }
            
        }
        
    }
    
    /*// MARK:-  UIViewControllerTransitioningDelegate
     
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
     
     } */
    
    
    // MARK:- Service Calls
    
    extension HomeViewController  {
        
        // Check For Service Status
        
        private func checkForProviderStatus() {
            
            if self.homePageHelper == nil {
                self.homePageHelper = HomePageHelper()
            }
            
            self.homePageHelper?.startListening(on: { (error, request) in
                
                if error != nil {
                    DispatchQueue.main.async {
                        showAlert(message: error?.localizedDescription, okHandler: nil, fromView: self)
                    }
                } else if request != nil {
                    print(request!)
                    
                    if let pLatitude = request?.provider?.latitude, let pLongitude = request?.provider?.longitude {
                        DispatchQueue.main.async {
                            self.moveProviderMarker(to: LocationCoordinate(latitude: pLatitude, longitude: pLongitude))
                        }
                    }
                    
                    guard self.riderStatus != request?.status else {
                        return
                    }
                    self.riderStatus = request?.status ?? .none
                    self.handle(request: request!)
                } else {
                    self.clearMapview()
                    self.removeUnnecessaryView(with: .none)
                }
            })
        }
        
        
        // Get Services provided by Provider
        
        private func getServicesList() {
            if self.sourceLocationDetail?.value != nil, self.destinationLocationDetail != nil { // Get Services only if location Available
                self.presenter?.get(api: .servicesList, parameters: nil)
            }
        }
        
        // Get Estimate Fare
        
        func getEstimateFareFor(serviceId : Int) {
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                var estimateFare = EstimateFareRequest()
                guard let sourceLocation = self.sourceLocationDetail?.value?.coordinate, let destinationLocation = self.destinationLocationDetail?.coordinate else {
                    return
                }
                estimateFare.s_latitude = sourceLocation.latitude
                estimateFare.s_longitude = sourceLocation.longitude
                estimateFare.d_latitude = destinationLocation.latitude
                estimateFare.d_longitude = destinationLocation.longitude
                estimateFare.service_type = serviceId
                
                self.presenter?.get(api: .estimateFare, parameters: estimateFare.JSONRepresentation)
                
            }
        }
        
      
        
        // Cancel Request
        
        func cancelRequest() {
            
            if self.currentRequestId>0 {
                let request = Request()
                request.request_id = self.currentRequestId
                self.presenter?.post(api: .cancelRequest, data: request.toData())
            }
        }
        
        
        // Create Request
        
        func createRequest(for service : Service, isScheduled : Bool, scheduleDate : Date?) {
            
            self.showLoaderView()
            DispatchQueue.global(qos: .background).async {
                
                let request = Request()
                request.s_address = self.sourceLocationDetail?.value?.address
                request.s_latitude = self.sourceLocationDetail?.value?.coordinate.latitude
                request.s_longitude = self.sourceLocationDetail?.value?.coordinate.longitude
                request.d_address = self.destinationLocationDetail?.address
                request.d_latitude = self.destinationLocationDetail?.coordinate.latitude
                request.d_longitude = self.destinationLocationDetail?.coordinate.longitude
                request.service_type = service.id
                request.payment_mode = .CASH
                request.distance = "\(service.pricing?.distance ?? 0)"
                request.use_wallet = service.pricing?.useWallet
                
                if isScheduled {
                    if let dateString = Formatter.shared.getString(from: scheduleDate, format: DateFormat.list.ddMMyyyyhhmma) {
                        
                        let dateArray = dateString.components(separatedBy: " ")
                        request.schedule_date = dateArray.first
                        request.schedule_time = dateArray.last
                    }
                }
                self.presenter?.post(api: .sendRequest, data: request.toData())
                
            }
        }
        
        // MARK:- Favourite Location on Other Category
        func favouriteLocationApi(in view : UIView, isAdd : Bool) {
            
            guard isAdd else { return }
            
            let service = Service() // Save Favourite location in Server
            service.type = CoreDataEntity.other.rawValue.lowercased()
            if view == self.viewFavouriteSource, let address = self.sourceLocationDetail?.value {
                service.address = address.address
                service.latitude = address.coordinate.latitude
                service.longitude = address.coordinate.longitude
            } else if view == self.viewFavouriteDestination, self.destinationLocationDetail != nil {
                service.address = self.destinationLocationDetail!.address
                service.latitude = self.destinationLocationDetail!.coordinate.latitude
                service.longitude = self.destinationLocationDetail!.coordinate.longitude
            } else { return }
            
            self.presenter?.post(api: .locationServicePostDelete, data: service.toData())
            
        }
    }
    
    // MARK:- PostViewProtocol
    
    extension HomeViewController : PostViewProtocol {
        
        func onError(api: Base, message: String, statusCode code: Int) {
            
            DispatchQueue.main.async {
                self.loader.isHidden = true
                showAlert(message: message, okHandler: nil, fromView: self)
                if api == .sendRequest {
                    self.removeLoaderView()
                }
            }
        }
        
        func getServiceList(api: Base, data: [Service]) {
            
            if api == .servicesList {
                DispatchQueue.main.async {  // Show Services
                    self.showRideNowView(with: data)
                }
            }
            
        }
        
//        func getEstimateFare(api: Base, data: EstimateFare?) {
//
//            if data != nil {
//                DispatchQueue.main.async {
//                    var estimateFare = data
//                    estimateFare?.model = self.service?.name
//                    //self.showRideNowView(with: estimateFare!)
//                }
//            }
//        }
        
        func getRequest(api: Base, data: Request?) {
            
            print(data?.request_id ?? 0)
            if api == .sendRequest {
                self.success(api: api, message: data?.message)
                self.currentRequestId = data?.request_id ?? 0
                self.checkForProviderStatus()
                DispatchQueue.main.async {
                    self.showLoaderView(with: self.currentRequestId)
                }
            }
//            self.currentRequestId = data?.request_id ?? 0
//            self.checkForProviderStatus()
            
        }
        
        func success(api: Base, message: String?) {
            
            self.loader.isHidden = true
            if api == .locationServicePostDelete {
                self.presenter?.get(api: .locationService, parameters: nil)
            }
            DispatchQueue.main.async {
                self.view.makeToast(message)
            }
        }
        
        func getLocationService(api: Base, data: LocationService?) {
            
            self.loader.isHideInMainThread(true)
            storeFavouriteLocations(from: data)
            
        }
        
        
    }
    
    
    

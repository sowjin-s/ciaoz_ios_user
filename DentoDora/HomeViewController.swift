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

class HomeViewController: UIViewController {
    
    @IBOutlet private var viewSideMenu : UIView!
    @IBOutlet private var viewCurrentLocation : UIView!
    @IBOutlet weak var viewMapOuter : UIView!
    @IBOutlet weak private var viewFavouriteSource : UIView!
    @IBOutlet weak private var viewFavouriteDestination : UIView!
    @IBOutlet weak private var viewSourceLocation : UIView!
    @IBOutlet weak private var viewDestinationLocation : UIView!
    @IBOutlet weak private var viewAddress : UIView!
    @IBOutlet weak var viewAddressOuter : UIView!
    @IBOutlet weak private var textFieldSourceLocation : UITextField!
    @IBOutlet weak private var textFieldDestinationLocation : UITextField!
    @IBOutlet weak private var imageViewMarkerCenter : UIImageView!
    @IBOutlet weak private var imageViewSideBar : UIImageView!
    @IBOutlet weak var buttonSOS : UIButton!
    
    var providerLastLocation = LocationCoordinate()
    lazy var markerProviderLocation : GMSMarker = {  // Provider Location Marker
        
        let marker = GMSMarker()
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        imageView.contentMode =  .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "map-vehicle-icon-black")
        marker.iconView = imageView
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
    
    
    private var sourceLocationDetail : Bind<LocationDetail>? = Bind<LocationDetail>(nil)
    
    var destinationLocationDetail : LocationDetail? {  // Destination Location Detail
        didSet{
            DispatchQueue.main.async {
                self.textFieldDestinationLocation.text = (self.destinationLocationDetail?.address.isEmpty ?? true) ? nil : self.destinationLocationDetail?.address
            }
        }
    }
    
  //  private var favouriteLocations : LocationService? //[(type : String,address: [LocationDetail])]() // Favourite Locations of User
    
    var currentLocation = Bind<LocationCoordinate>(defaultMapLocation)
    
    var serviceSelectionView : ServiceSelectionView?
    var rideSelectionView : RequestSelectionView?
    var requestLoaderView : LoaderView?
    var rideStatusView : RideStatusView?
    var invoiceView : InvoiceView?
    var ratingView : RatingView?
    
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    var currentRequestId = 0
    
    //MARKERS
    
    private var sourceMarker = GMSMarker()
    private var destinationMarker = GMSMarker()
    
    var service : Service?
    var homePageHelper : HomePageHelper?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.localize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewLayouts()
    }
    
//    var tempLat = 13.05864944
//    var tempLong = 80.25398977

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
        
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.serviceView)))
        
        self.sourceLocationDetail?.bind(listener: { (locationDetail) in
            DispatchQueue.main.async {
                self.textFieldSourceLocation.text = locationDetail?.address
            }
        })
        self.viewDestinationLocation.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        self.checkForProviderStatus()
        self.buttonSOS.isHidden = true
        self.buttonSOS.addTarget(self, action: #selector(self.buttonSOSAction), for: .touchUpInside)
        
        
//        let timer =  Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { (_) in
//
//            self.tempLat -= 0.00002
//            self.tempLong -= 0.00002
//            self.moveProviderMarker(to: LocationCoordinate(latitude: self.tempLat, longitude: self.tempLong))
//        }
//        timer.fire()
    }
    
    
    // MARK:- View Will Layouts
    
    private func viewLayouts() {
        
        self.viewCurrentLocation.makeRoundedCorner()
        self.mapViewHelper?.mapView?.frame = viewMapOuter.bounds
        
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
            if self.sourceLocationDetail?.value == nil {
                self.mapViewHelper?.getPlaceAddress(from: location.coordinate, on: { (locationDetail) in
                    self.sourceLocationDetail?.value = locationDetail
                   // self.getProviderInCurrentLocation()
                })
            }
            self.currentLocation.value = location.coordinate
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
        marker.icon = marker == self.sourceMarker ? #imageLiteral(resourceName: "destinationPin").resizeImage(newWidth: 30) : #imageLiteral(resourceName: "sourcePin").resizeImage(newWidth: 30)
        marker.map = self.mapViewHelper?.mapView
        marker.map?.center = viewMapOuter.center
        self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
    }
    
    
    // MARK:- Show Location View
    
    private func showLocationView() {
        
        if let locationView = Bundle.main.loadNibNamed(XIB.Names.LocationSelectionView, owner: self, options: [:])?.first as? LocationSelectionView {
            locationView.frame = self.view.bounds
            locationView.setValues(address: (sourceLocationDetail,destinationLocationDetail)) { (address) in
                
                self.sourceLocationDetail = address.source
                self.destinationLocationDetail = address.destination
                self.drawPolyline() // Draw polyline between source and destination
                self.getServicesList() // get Services
            }
            self.view.addSubview(locationView)
            
            self.selectedLocationView.transform = .identity
            self.selectedLocationView = UIView()
        }
        
    }
    
    //MARK:- Draw Polyline
    
     func drawPolyline() {
        
        if let sourceCoordinate = self.sourceLocationDetail?.value?.coordinate,
           let destinationCoordinate = self.destinationLocationDetail?.coordinate {  // Draw polyline from source to destination
            self.mapViewHelper?.mapView?.clear()
            self.selectionViewAction(in: self.viewSourceLocation)
            self.selectionViewAction(in: self.viewDestinationLocation)
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
        print("ViewAddressOuter ", #function)
    } else {
         self.drawerController?.openSide(.left)
    }
    
       // self.serviceView()
       // self.showRideNowView()
         // self.showRideStatusView()
      // self.showInvoiceView()
       //  self.showRatingView()
    
    }
    
    // MARK:- Add or remove lottie View
    
    private func isAddLottie(view lottieView : inout LottieView?,in viewToBeAdded : UIView, isAdd : Bool){
        
        if isAdd {
            let frame =  view.bounds//CGRect(x: viewToBeAdded.frame.maxX/2, y: viewToBeAdded.frame.maxY/2, width: viewToBeAdded.frame.width/2, height: viewToBeAdded.frame.height/2)
            lottieView = LottieHelper().addLottie(with: frame)
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
    
    // MARK:- Show DateTimePicker
    
    func schedulePickerView(on completion : @escaping ((Date)->())){
        
        var dateComponents = DateComponents()
        dateComponents.day = 60
        let now = Date()
        let calendar = Calendar.current.date(byAdding: dateComponents, to: now)
        let datePicker = DateTimePicker.show(selected: nil, minimumDate: now, maximumDate: calendar, timeInterval: .default)
        datePicker.includeMonth = true
        datePicker.is12HourFormat = true
        datePicker.dateFormat = DateFormat.list.hhmmddMMMyyyy
        datePicker.highlightColor = .primary
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
            self.isMapInteracted(false)
            if [self.viewSourceLocation, self.viewDestinationLocation].contains(selectedLocationView) {
                self.drawPolyline()
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        
        print("Gesture ",gesture)
        self.isUserInteractingWithMap = gesture
        
        if self.isUserInteractingWithMap {
            self.isMapInteracted(true)
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        print(#function)
       // return
        
        if isUserInteractingWithMap {
            
            if self.selectedLocationView == self.viewSourceLocation, self.sourceLocationDetail != nil {
                
                self.sourceMarker.map = nil
                self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "destinationPin")
                self.imageViewMarkerCenter.isHidden = false
                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    self.sourceLocationDetail?.value?.coordinate = location
                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                        print(locationDetail)
                        self.sourceLocationDetail?.value = locationDetail
//                        let sLocation = self.sourceLocationDetail
//                        self.sourceLocationDetail = sLocation
                    })
                }
                
                
            } else if self.selectedLocationView == self.viewDestinationLocation, self.destinationLocationDetail != nil {
                
                self.destinationMarker.map = nil
                self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "sourcePin")
                self.imageViewMarkerCenter.isHidden = false
                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    self.destinationLocationDetail?.coordinate = location
                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                        print(locationDetail)
                        self.destinationLocationDetail = locationDetail
                    })
                }
            }
            
        }
        else {
            self.destinationMarker.map = self.mapViewHelper?.mapView
            self.sourceMarker.map = self.mapViewHelper?.mapView
            self.imageViewMarkerCenter.isHidden = true
        }
        
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
                self.removeUnnecessaryView(with: .none)
            }
        })
    }
    
    
    // Get Services provided by Provider 
    
    private func getServicesList() {
        
        self.presenter?.get(api: .servicesList, parameters: nil)
        
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
    
    // Get Providers In Current Location
    
    private func getProviderInCurrentLocation(){
        
        DispatchQueue.global(qos: .background).async {
            
            guard let currentLoc = self.currentLocation.value  else { return }
            
            let json = [Constants.string.latitude : currentLoc.latitude, Constants.string.longitude : currentLoc.longitude]
            
            self.presenter?.get(api: .getProviders, parameters: json)
            
        }
        
    }
    
    // Create Request
    
    func createRequest(for fare : EstimateFare, isScheduled : Bool, scheduleDate : Date?) {
      
        self.removeRideNowView()
        self.showLoaderView()
        DispatchQueue.global(qos: .background).async {
            
            let request = Request()
            request.d_address = self.destinationLocationDetail?.address
            request.d_latitude = self.destinationLocationDetail?.coordinate.latitude
            request.d_longitude = self.destinationLocationDetail?.coordinate.longitude
            request.s_address = self.sourceLocationDetail?.value?.address
            request.s_latitude = self.sourceLocationDetail?.value?.coordinate.latitude
            request.s_longitude = self.sourceLocationDetail?.value?.coordinate.longitude
            request.service_type = self.service?.id
            request.payment_mode = .CASH
            request.distance = "\(fare.distance ?? 0)"
            request.use_wallet = fare.useWallet
            
            if isScheduled {
                if let dateString = Formatter.shared.getString(from: scheduleDate, format: DateFormat.list.ddMMyyyyhhmma) {
                    
                    let dateArray = dateString.components(separatedBy: "")
                    request.schedule_date = dateArray.first
                    request.schedule_time = dateArray.last
                }
            }
            self.presenter?.post(api: .sendRequest, data: request.toData())
            
        }
    }
}

// MARK:- PostViewProtocol

extension HomeViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
             self.loader.isHidden = true
             //self.removeLoaderViewAndClearMapview()
             showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getServiceList(api: Base, data: [Service]) {
        
        if api == .getProviders {  // Show Providers in Current Location
            DispatchQueue.main.async {
               // self.showProviderInCurrentLocation(with: data)
                //TODO:- Map Load to be fixed
            }
            return
        }
        DispatchQueue.main.async {  // Show Services
            self.showServiceSelectionView(with: data)
        }
        
    }
    
    func getEstimateFare(api: Base, data: EstimateFare?) {
       
        if data != nil {
            DispatchQueue.main.async {
                var estimateFare = data
                estimateFare?.model = self.service?.name
                self.showRideNowView(with: estimateFare!)
            }
        }
    }
    
    func getRequest(api: Base, data: Request?) {
        
        print(data?.request_id ?? 0)
        self.currentRequestId = data?.request_id ?? 0
        self.checkForProviderStatus()
        
    }
    
    func success(api: Base, message: String?) {
        
        if api == .locationServicePostDelete {
            self.presenter?.get(api: .locationService, parameters: nil)
        }
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.view.makeToast(message)
        }
    }
    
    func getLocationService(api: Base, data: LocationService?) {
        
        storeFavouriteLocations(from: data)
    }
    
}




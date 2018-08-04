//
//  RideNowView.swift
//  User
//
//  Created by CSS on 27/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RideNowView: UIView {
    
    @IBOutlet private weak var viewCurve : UIView!
    @IBOutlet private weak var labelSurge : UILabel!
    @IBOutlet private weak var labelSurgeDescription : UILabel!
    @IBOutlet private weak var viewSurge: UIView!
    @IBOutlet private weak var labelCapacity : UILabel!
    @IBOutlet weak var labelCardNumber : UILabel!
    @IBOutlet weak var imageViewCard : UIImageView!
    @IBOutlet weak var progressView : UIProgressView!
    @IBOutlet private weak var collectionViewService : UICollectionView!
    @IBOutlet private weak var buttonSchedule : UIButton!
    @IBOutlet private weak var buttonRideNow : UIButton!
    // @IBOutlet private weak var labelServiceTitle : UILabel!
    @IBOutlet private weak var imageViewWallet : ImageView!
    @IBOutlet private weak var viewWallet : UIView!
    @IBOutlet private weak var labelWallet : UILabel!
    @IBOutlet private weak var viewPayment : UIView!
    @IBOutlet private weak var labelWalletAmount : UILabel!
    
    private var datasource = [Service]()
    var onClickChangePayment : (()->Void)? // Onclick Change Pricing
    var onClickSchedule : ((Service?)->Void)? // Onclick schedule
    var onClickRideNow : ((Service?)->Void)? // Onlclick Ride Now
    private var rateView : RateView?
    private var selectedItem : Service?
    private var timer : Timer?
    private let timerSchedule : TimeInterval = 30
    private var timerValue : TimeInterval = 0
    
    private var sourceCoordinate = LocationCoordinate()
    private var destinationCoordinate = LocationCoordinate()
    private var selectedRow = -1

    var isWalletChecked = false {  // Handle Wallet
        didSet {
            self.imageViewWallet.image = (isWalletChecked ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check-box-empty")).withRenderingMode(.alwaysTemplate)
        }
    }
    
    private var isSurge = false {
        didSet {
            UIView.animate(withDuration: 0.5) {
                self.viewSurge.alpha = self.isSurge ? 1 : 0
            }
        }
    }
    
    var isShowWallet  = false {
        
        didSet {
            self.viewWallet.isHidden = !isShowWallet
            self.labelWalletAmount.isHidden = !isShowWallet
        }
        
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        self.localize()
        self.setDesign()
    }
}

extension RideNowView {
    
    private func initialLoads() {
        
        self.collectionViewService.delegate = self
        self.collectionViewService.dataSource = self
        self.collectionViewService.register(UINib(nibName: XIB.Names.ServiceSelectionCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: XIB.Names.ServiceSelectionCollectionViewCell)
        self.buttonSchedule.addTarget(self, action: #selector(self.buttonActions(sender:)), for: .touchUpInside)
        self.buttonRideNow.addTarget(self, action: #selector(self.buttonActions(sender:)), for: .touchUpInside)
        self.imageViewCard.image = #imageLiteral(resourceName: "money_icon")
        self.labelCardNumber.text = Constants.string.cash.localize()
        let layer = viewCurve.createCircleShapeLayer(strokeColor: .clear, fillColor: .black)
        self.viewCurve.layer.insertSublayer(layer, below: labelSurge.layer)
        self.viewWallet.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(sender:))))
        self.viewPayment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction(sender:))))
        //self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.panAction(sender:))))
        self.isWalletChecked = false
        self.viewSurge.alpha = 0
        self.isShowWallet = false
        self.initializeRateView()
        self.setProgressView()
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        //Common.setFont(to: labelServiceTitle, isTitle: true)
        Common.setFont(to: buttonRideNow, isTitle: true)
        Common.setFont(to: buttonSchedule, isTitle: true)
        Common.setFont(to: labelSurge, isTitle: true)
        Common.setFont(to: labelSurgeDescription)
        Common.setFont(to: labelCapacity)
        Common.setFont(to: labelCardNumber)
        Common.setFont(to: labelWallet)
        Common.setFont(to: labelWalletAmount, isTitle: true)
        
    }
    
    // MARK:- Localize
    
    private func localize(){
        self.buttonSchedule.setTitle(Constants.string.scheduleRide.localize().uppercased(), for: .normal)
        self.buttonRideNow.setTitle(Constants.string.rideNow.localize().uppercased(), for: .normal)
        // self.labelServiceTitle.text = Constants.string.service.localize()
        self.labelWallet.text = Constants.string.wallet.localize()
        self.labelSurgeDescription.text = Constants.string.peakInfo.localize()
    }
    
    // MARK:- Button Actions
    
    @IBAction private func buttonActions(sender : UIButton) {
        
        guard self.selectedItem?.pricing != nil else {
            UIApplication.shared.keyWindow?.makeToast(Constants.string.pleaseTryAgain.localize())
            return
        }
        self.selectedItem?.pricing?.useWallet = self.isWalletChecked.hashValue // send wallet status
        
        if sender == buttonSchedule {
            self.onClickSchedule?(self.selectedItem)
        } else if sender == buttonRideNow {
            self.onClickRideNow?(self.selectedItem)
        }
    }
    
    // MARK:- View Wallet
    
    @IBAction private func tapGestureAction(sender : UITapGestureRecognizer) {
        guard let senderView = sender.view else { return }
        if senderView == self.viewPayment {  // Is Clicking change payment
            self.onClickChangePayment?()
        } else if senderView == self.viewWallet {  // Is Clicking add or remove wallet amount
            self.isWalletChecked = !isWalletChecked
        }
    }
    
    // Getting service array from  Homeviewcontroller
    func set(source : [Service]) {
        
        self.selectedRow = -1
        self.datasource = source
        self.collectionViewService.reloadData()
        self.collectionView(collectionViewService, didSelectItemAt: IndexPath(item: 0, section: 0))
        
    }
    
    // Setting address from HomeViewController
    func setAddress(source : LocationCoordinate, destination : LocationCoordinate) {
        
        self.sourceCoordinate = source
        self.destinationCoordinate = destination
        
    }
    
    // MARK:- Initialize Rate View
    
    private func initializeRateView() {
        
        if self.rateView == nil {
            self.rateView = Bundle.main.loadNibNamed(XIB.Names.RateView, owner: self, options: [:])?.first as? RateView
            self.rateView?.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.height-self.rateView!.frame.height), size: CGSize(width: self.frame.width, height: self.rateView!.frame.height))
            self.rateView?.onCancel = {
                self.removeRateView()
            }
            self.addSubview(self.rateView!)
            self.rateView?.alpha = 0
        }
        // self.rateView?.set(values: self.selectedItem)
        
    }
    
    // MARK:- Remove Rate View
    
    private func removeRateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.rateView?.frame.origin.y += (self.rateView?.frame.height) ?? 0
            self.rateView?.alpha = 0
        }) { (_) in
            self.rateView?.frame.origin.y -= (self.rateView?.frame.height) ?? 0
        }
    }
    
    // MARK:- Show Rate View
    
    private func showRateView() {
        
        UIView.animate(withDuration: 0.5) {
            self.rateView?.alpha = 1
        }
        self.rateView?.set(values: self.selectedItem)
        self.rateView?.show(with: .bottom, completion: nil)
        
    }
    
    /*@IBAction private func panAction(sender : UIPanGestureRecognizer) {
     
     /*  guard !isPresented else {
     return
     }
     if sender.state == .began {
     
     self.addRateView()
     self.setTransform(transform: CGAffineTransform(scaleX: 0, y: 0), alpha: 0)
     
     }else */
     if sender.state == .changed {
     let point = sender.translation(in: UIApplication.shared.keyWindow ?? self)
     print("point  ",point)
     let value = (abs(point.y)/self.frame.height)*1.5
     UIView.animate(withDuration: 0.3) {
     self.setTransform(transform: CGAffineTransform(scaleX: value, y: value), alpha: value)
     }
     if value>0.6 {
     //self.isPresented = true
     UIView.animate(withDuration: 0.3) {
     self.setTransform(transform: .identity, alpha: 1)
     }
     }
     
     } else {
     UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
     self.setTransform(transform: CGAffineTransform(scaleX: 0, y: 0), alpha: 0)
     }, completion: { _ in
     self.removeRateView()
     })
     }
     
     }
     
     // MARK:- Transform View
     
     private func setTransform(transform : CGAffineTransform, alpha : CGFloat) {
     
     self.rateView?.alpha = alpha
     self.rateView?.transform = transform
     self.rateView?.center = CGPoint(x: self.rateView!.frame.width/2, y: self.frame.height-(self.rateView!.frame.height/2))
     
     } */
    
    
    // Get Estimate Fare
    
    func getEstimateFareFor(serviceId : Int) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            guard self.sourceCoordinate.latitude>0, self.sourceCoordinate.longitude>0, self.destinationCoordinate.latitude>0, self.destinationCoordinate.longitude>0 else {
                return
            }
            var estimateFare = EstimateFareRequest()
            estimateFare.s_latitude = self.sourceCoordinate.latitude
            estimateFare.s_longitude = self.sourceCoordinate.longitude
            estimateFare.d_latitude = self.destinationCoordinate.latitude
            estimateFare.d_longitude = self.destinationCoordinate.longitude
            estimateFare.service_type = serviceId
            self.presenter?.get(api: .estimateFare, parameters: estimateFare.JSONRepresentation)
        }
        self.resetProgressView()
        self.startProgressing()
    }
    
    // Get Providers In Current Location
    
    private func getProviders(by serviceId : Int){
        
        DispatchQueue.global(qos: .background).async {
            
          //  guard let currentLoc = self.sourceCoordinate .value  else { return }
            
            let json = [Constants.string.latitude : self.sourceCoordinate.latitude, Constants.string.longitude : self.sourceCoordinate.longitude, Constants.string.service : serviceId] as [String : Any]
            
            self.presenter?.get(api: .getProviders, parameters: json)
            
        }
        
    }
    
    // MARK:- Set Progress View
    private func setProgressView() {
        
        self.progressView.progressTintColor = .secondary
        self.resetProgressView()
        self.progressView.progressViewStyle = .bar
        
    }
    
    // MARK:- Reset Progress view
    private func resetProgressView() {
        DispatchQueue.main.async {
            self.progressView.progress = 0
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    private func startProgressing() {
        DispatchQueue.main.async {
            self.timerValue = 0
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
            self.timer?.fire()
        }
    }
    
    
    @IBAction private func timerAction() {
        self.timerValue  += 5
        CATransaction.begin()
        CATransaction.setAnimationDuration(2)
        CATransaction.setCompletionBlock {
             self.progressView.progress = Float(self.timerValue/self.timerSchedule)
        }
        CATransaction.commit()
    }
    
    // MARK:- Set Surge View
    
    private func setSurgeViewAndWallet() {
        
        if self.datasource.count>selectedRow, self.datasource[selectedRow].pricing != nil {
            self.labelSurge.text = self.datasource[selectedRow].pricing?.surge_value
            self.isSurge = self.datasource[selectedRow].pricing?.surge == true.hashValue
            self.isShowWallet = !(self.datasource[selectedRow].pricing?.wallet_balance == 0)
            self.labelWalletAmount.text = " \(String.removeNil(User.main.currency)) \(self.datasource[selectedRow].pricing?.wallet_balance ?? 0)"
        }
        
    }
    
}


extension RideNowView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return self.getCellFor(itemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/4.5)
        let height = collectionView.frame.height-12
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.select(at: indexPath)
    }
    
    private func getCellFor(itemAt indexPath : IndexPath)->UICollectionViewCell{
        
        if let collectionCell = self.collectionViewService.dequeueReusableCell(withReuseIdentifier: XIB.Names.ServiceSelectionCollectionViewCell, for: indexPath) as? ServiceSelectionCollectionViewCell {
            if datasource.count > indexPath.row {
                collectionCell.set(value: datasource[indexPath.row])
                if self.selectedRow == indexPath.row {
                    if !collectionCell.isSelected {
                        collectionCell.isSelected = true
                    }
                } else {
                    collectionCell.isSelected = false
                }
            }
            return collectionCell
        }
        
        return UICollectionViewCell()
    }
    
    
    private func select(at indexPath : IndexPath) {
        
        if datasource.count>indexPath.row, let id = datasource[indexPath.row].id {
            self.isSurge = false // Hide surge till api loaded
            self.collectionViewService.cellForItem(at: IndexPath(item: self.selectedRow, section: 0))?.isSelected = false
            if self.selectedRow == indexPath.row {
                self.showRateView()
                return
            }
            self.selectedItem = self.datasource[indexPath.row]
            self.labelCapacity.text = "1-\(Int.removeNil(self.selectedItem?.capacity))"
            self.selectedRow = indexPath.row
            self.setSurgeViewAndWallet()
            self.getProviders(by: id)
        }
        
        if selectedItem?.pricing == nil, let id = self.selectedItem?.id {
            self.getEstimateFareFor(serviceId: id)
        }
    }
}

// MARK:- PostViewProtocol

extension RideNowView : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.make(toast: message)
            self.resetProgressView()
        }
    }
    
    func getEstimateFare(api: Base, data: EstimateFare?) {
        if let index = self.datasource.index(where: { $0.id == data?.service_type }) {
            self.datasource[index].pricing = data
            DispatchQueue.main.async {
                self.resetProgressView()
                self.setSurgeViewAndWallet()
                self.collectionViewService.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    func getServiceList(api: Base, data: [Service]) {
        
        if api == .getProviders {  // Show Providers in Current Location
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .providers, object: nil, userInfo: [Notification.Name.providers.rawValue: data])
            }
        }
    }
    
    
}




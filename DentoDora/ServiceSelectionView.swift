//
//  ServiceSelectionView.swift
//  User
//
//  Created by CSS on 11/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class ServiceSelectionView: UIView {
    
    @IBOutlet private weak var collectionViewService : UICollectionView!
    @IBOutlet private weak var labelServiceTitle : UILabel!
    @IBOutlet var buttonService : UIButton!
    @IBOutlet var buttonMore : UIButton!
    @IBOutlet private weak var buttonChange : UIButton!
    @IBOutlet private weak var labelCapacity : UILabel!
    @IBOutlet private weak var buttonGetPricing : UIButton!
    @IBOutlet weak var labelCardNumber : UILabel!
    @IBOutlet weak var imageViewCard : UIImageView!
  
    private var rateView : RateView?
    
    var isServiceSelected = true {
        didSet{
            self.changeCollectionData()
        }
    }
    
    private var datasource = [Service]()
    var onClickPricing : ((_ selectedItem : Service?)->Void)? // Get Pricing List
    var onClickChangePayment : (()->Void)? // Onlclick Change Pricing

    
    private var selectedItem : Service? // Current Selected Item
    private var selectedRow = -1
    private var sourceCoordinate = LocationCoordinate()
    private var destinationCoordinate = LocationCoordinate()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
        self.localize()
    }

}

// MARK:- Methods

extension ServiceSelectionView {
    
    private func initialLoads() {
        
        self.collectionViewService.delegate = self
        self.collectionViewService.dataSource = self
        self.collectionViewService.register(UINib(nibName: XIB.Names.ServiceSelectionCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: XIB.Names.ServiceSelectionCollectionViewCell)
        self.isServiceSelected = true
        self.buttonGetPricing.addTarget(self, action: #selector(self.onClickGetPricing), for: .touchUpInside)
        self.imageViewCard.image = #imageLiteral(resourceName: "money_icon")
        self.labelCardNumber.text = Constants.string.cash.localize()
        self.setDesign()
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
        Common.setFont(to: labelServiceTitle, isTitle: true)
        Common.setFont(to: buttonMore)
        Common.setFont(to: buttonService)
       // Common.setFont(to: buttonChange)
        Common.setFont(to: buttonChange, isTitle: true)
        Common.setFont(to: labelCapacity)
        Common.setFont(to: labelCardNumber)
        
    }
    
    
    // MARK:- Localize
    
    private func localize(){
        
        self.buttonMore.setTitle(Constants.string.more.localize(), for: .normal)
        self.buttonService.setTitle(Constants.string.service.localize(), for: .normal)
        //self.buttonChange.setTitle(Constants.string.change.localize().uppercased(), for: .normal)
        self.buttonGetPricing.setTitle(Constants.string.getPricing.localize(), for: .normal)
        
    }
    
    private func changeCollectionData(){
        DispatchQueue.main.async {
            self.labelServiceTitle.text = (self.isServiceSelected ? Constants.string.selectService : Constants.string.more).localize()
            self.buttonService.isHidden = self.isServiceSelected
         //   self.buttonMore.isHidden = !self.isServiceSelected
            self.collectionViewService.reloadData()
        }
    }
    
    func setAddress(source : LocationCoordinate, destination : LocationCoordinate) {
        
        self.sourceCoordinate = source
        self.destinationCoordinate = destination
        
    }
    
    
    //MARK:- Set Source 
    func set(source : [Service]) {
        
        self.datasource = source
        self.collectionViewService.reloadData()
        //self.collectionViewService.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
        self.selectedItem = source.first
//        self.collectionViewService.cellForItem(at: IndexPath(item: 0, section: 0))?.isSelected = true
//        if let id = source.first?.id {
//            self.getEstimateFareFor(serviceId: id)
//        }
        self.collectionView(self.collectionViewService, didSelectItemAt: IndexPath(item: 0, section: 0))
        
    }
    
    @IBAction private func onClickGetPricing() {
        self.onClickPricing?(self.selectedItem)
    }
    
    // MARK:- Show Rate View
    
    private func showRateView() {
        
        if self.rateView == nil {
            self.rateView = Bundle.main.loadNibNamed(XIB.Names.RateView, owner: self, options: [:])?.first as? RateView
            self.rateView?.frame = CGRect(origin: CGPoint(x: 0, y: self.frame.height-self.rateView!.frame.height), size: CGSize(width: self.frame.width, height: self.rateView!.frame.height))
            self.rateView?.onCancel = {
                self.rateView?.dismissView(onCompletion: {
                    self.rateView = nil
                })
            }
            self.addSubview(self.rateView!)
            self.rateView?.show(with: .bottom, completion: nil)
        }
        
        self.rateView?.set(values: self.selectedItem)
        
    }
    
    // Get Estimate Fare
    
    func getEstimateFareFor(serviceId : Int) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            
            var estimateFare = EstimateFareRequest()
            estimateFare.s_latitude = self.sourceCoordinate.latitude
            estimateFare.s_longitude = self.sourceCoordinate.longitude
            estimateFare.d_latitude = self.destinationCoordinate.latitude
            estimateFare.d_longitude = self.destinationCoordinate.longitude
            estimateFare.service_type = serviceId
            self.presenter?.get(api: .estimateFare, parameters: estimateFare.JSONRepresentation)
            
        }
    }
    
}



// MARK:- UICollectionView

extension ServiceSelectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return self.getCellFor(itemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if datasource.count>indexPath.row {
            
            if selectedRow == indexPath.row {
                showRateView()
            }
            self.selectedRow = indexPath.row
            self.selectedItem = self.datasource[indexPath.row]
            self.labelCapacity.text = "1-\(Int.removeNil(self.selectedItem?.capacity))"
            if selectedItem?.pricing == nil, let id = self.selectedItem?.id {
                self.getEstimateFareFor(serviceId: id)
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/3.5)
        let height = collectionView.frame.height-10
        return CGSize(width: width, height: height)
    }
    
    private func getCellFor(itemAt indexPath : IndexPath)->UICollectionViewCell{
        
        if let collectionCell = self.collectionViewService.dequeueReusableCell(withReuseIdentifier: XIB.Names.ServiceSelectionCollectionViewCell, for: indexPath) as? ServiceSelectionCollectionViewCell {
            if datasource.count > indexPath.row {
                collectionCell.set(value: datasource[indexPath.row])
            }
            collectionCell.isSelected = indexPath.row == selectedRow
            return collectionCell
        }
        
        return UICollectionViewCell()
    }
    
}

// MARK:- PostViewProtocol

extension ServiceSelectionView : PostViewProtocol {
    
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
            self.make(toast: message)
        }
    }
    
    
    func getEstimateFare(api: Base, data: EstimateFare?) {
        
        if self.datasource.count > selectedRow {
            self.datasource[selectedRow].pricing = data
            DispatchQueue.main.async {
                self.collectionViewService.reloadItems(at: [IndexPath(item: self.selectedRow, section: 0)])
            }
        }
        
    }
    
}



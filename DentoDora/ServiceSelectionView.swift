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
    
    var isServiceSelected = true {
        didSet{
            self.changeCollectionData()
        }
    }
    
    private var datasource = [Service]()
    var onClickPricing : ((_ selectedItem : Service?)->Void)? // Get Pricing List
    var onClickChangePayment : (()->Void)? // Onlclick Change Pricing
    
    private var selectedItem : Service? // Current Selected Item
    
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
    
    //MARK:- Set Source 
    func set(source : [Service]) {
        self.datasource = source
        self.collectionViewService.reloadData()
        self.collectionViewService.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .top)
        self.selectedItem = source.first
        self.collectionViewService.cellForItem(at: IndexPath(item: 0, section: 0))?.isSelected = true
    }
    
    @IBAction private func onClickGetPricing() {
        self.onClickPricing?(self.selectedItem)
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
            self.selectedItem = self.datasource[indexPath.row]
            self.labelCapacity.text = "1-\(Int.removeNil(self.selectedItem?.capacity))"
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
            
            return collectionCell
        }
        
        return UICollectionViewCell()
    }
    
}




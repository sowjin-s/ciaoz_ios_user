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
    @IBOutlet private weak var buttonGetPricing : UIButton!
    @IBOutlet private weak var labelCardNumber : UILabel!
    @IBOutlet private weak var imageViewCard : UIImageView!
    
    var isServiceSelected = true {
        didSet{
            self.changeCollectionData()
        }
    }
    
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
    }
    
    // MARK:- Localize
    
    private func localize(){
        
        self.buttonMore.setTitle(Constants.string.more.localize(), for: .normal)
        self.buttonService.setTitle(Constants.string.service.localize(), for: .normal)
        self.buttonChange.setTitle(Constants.string.change.localize().uppercased(), for: .normal)
        self.buttonGetPricing.setTitle(Constants.string.getPricing.localize(), for: .normal)
        
    }
    
    private func changeCollectionData(){
        
        DispatchQueue.main.async {
            
            self.labelServiceTitle.text = (self.isServiceSelected ? Constants.string.selectService : Constants.string.more).localize()
            self.buttonService.isHidden = self.isServiceSelected
            self.buttonMore.isHidden = !self.isServiceSelected
            self.collectionViewService.reloadData()
        }
    }
    
    
}



// MARK:- UICollectionView

extension ServiceSelectionView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return self.getCellFor(itemAt: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/3.5)
        let height = collectionView.frame.height-10
        return CGSize(width: width, height: height)
    }
    
    private func getCellFor(itemAt indexPath : IndexPath)->UICollectionViewCell{
        
        if let collectionCell = self.collectionViewService.dequeueReusableCell(withReuseIdentifier: XIB.Names.ServiceSelectionCollectionViewCell, for: indexPath) as? ServiceSelectionCollectionViewCell {
            
            return collectionCell
        }
        
        
        return UICollectionViewCell()
    }
    
}



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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionViewService.delegate = self
        self.collectionViewService.dataSource = self
        self.collectionViewService.register(UINib(nibName: XIB.Names.ServiceSelectionCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: XIB.Names.ServiceSelectionCollectionViewCell)
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
        
        return CGSize(width: collectionView.frame.width-10, height: collectionView.frame.height-10)
    }
    
    private func getCellFor(itemAt indexPath : IndexPath)->UICollectionViewCell{
        
        
        
        
        return UICollectionViewCell()
    }
    
}

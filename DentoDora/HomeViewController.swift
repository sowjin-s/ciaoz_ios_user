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
    
    private var viewMap : GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK:- Methods

extension HomeViewController {
    
    private func initialLoads(){
        
        self.addMapView()
        self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    // MARK:- Add Mapview
    
    private func addMapView(){
        
        self.viewMap = GMSMapView(frame: self.view.frame)
        self.viewMap.delegate = self
        self.view.addSubview(viewMap)
        
    }
    
    
    
    
    // MARK:- SideMenu Button Action
    
   @IBAction private func sideMenuAction(){
        
        self.drawerController?.openSide(.left)
        
    }
}


// MARK:- MapView

extension HomeViewController : GMSMapViewDelegate {
    
    
    
}

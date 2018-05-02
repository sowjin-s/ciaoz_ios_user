//
//  HomeViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import KWDrawerController

class HomeViewController: UIViewController {
    
    @IBOutlet private var viewSideMenu : UIView!

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
        
        self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
        
    }
    
    
    // MARK:- SideMenu Button Action
    
   @IBAction private func sideMenuAction(){
        
        self.drawerController?.openSide(.left)
        
    }
}

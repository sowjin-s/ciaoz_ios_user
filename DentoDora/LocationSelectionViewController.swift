//
//  LocationSelectionViewController.swift
//  User
//
//  Created by CSS on 04/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class LocationSelectionViewController: UIViewController {
    
    @IBOutlet private weak var viewTop : UIView!
    @IBOutlet private weak var viewBottom : UIView!

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

extension LocationSelectionViewController {
    
    private func initialLoads() {
        
        self.viewBottom.show(with: .bottom, duration: 1, completion: nil)
        
    }
    
}

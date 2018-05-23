//
//  Identifiers.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation

// MARK:- Storyboard Id
struct Storyboard {
    
    static let Ids = Storyboard()
    
    let LaunchViewController = "LaunchViewController"
    let EmailViewController = "EmailViewController"
    let PasswordViewController = "PasswordViewController"
    let ForgotPasswordViewController = "ForgotPasswordViewController"
    let SocialLoginViewController = "SocialLoginViewController"
    let SignUpTableViewController = "SignUpTableViewController"
    let WalkThroughPreviewController = "WalkThroughPreviewController"
    let DrawerController = "DrawerController"
    let ProfileViewController = "ProfileViewController"
    let LocationSelectionViewController = "LocationSelectionViewController"
    
}




//MARK:- XIB Cell Names

struct XIB {
    
    static let Names = XIB()
    let WalkThroughView = "WalkThroughView"
    let LocationTableViewCell = "LocationTableViewCell"
    let LocationHeaderTableViewCell = "LocationHeaderTableViewCell"
    let ServiceSelectionCollectionViewCell = "ServiceSelectionCollectionViewCell"
    let LocationSelectionView = "LocationSelectionView"
    let ServiceSelectionView = "ServiceSelectionView"
    let RequestSelectionView = "RequestSelectionView"
    let LoaderView = "LoaderView"
    let RideStatusView = "RideStatusView"
}



//MARK:- Notification

extension Notification.Name {
   //public static let reachabilityChanged = Notification.Name("reachabilityChanged")
}




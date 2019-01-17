//
//  AppData.swift
//  User
//
//  Created by CSS on 10/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

let AppName = "Tranxit"
var deviceTokenString = Constants.string.noDevice
let googleMapKey = "AIzaSyCKTSqyNLap7VgehJft0j9amCn52i0u7tQ"
let appSecretKey = "yVnKClKDHPcDlqqO1V05RtDRdvtrVHfvjlfqliha"
let appClientId = 2
let defaultMapLocation = LocationCoordinate(latitude: 13.009245, longitude: 80.212929)
//let locationApi = "https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@"
let baseUrl = "http://schedule.deliveryventure.com/" //"https://schedule.tranxit.co/"
let passwordLengthMax = 10
//let distanceType = "km"
let requestCheckInterval : TimeInterval = 5
//var sosNumber = 911

var supportNumber = "919585290750"
var supportEmail = "support@tranxit.com"
var offlineNumber = "57777"
let stripePublishableKey = "pk_test_DbfzA8Pv1MDErUiHakK9XfLe"
let helpSubject = "\(AppName) Help"
let driverUrl = "https://itunes.apple.com/us/app/tranxit-driver/id1204269279?mt=8"
let userAppStoreUtl = "https://itunes.apple.com/us/app/tranxit/id1204487551?ls=1&mt=8"
let requestInterval : TimeInterval = 60  // seconds


enum AppStoreUrl : String {
    
    case user = "https://itunes.apple.com/us/app/tranxit/id1204487551?ls=1&mt=8"
    case driver = "https://itunes.apple.com/us/app/tranxit-driver/id1204269279?mt=8"
    
}

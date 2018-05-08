//
//  LottieHelper.swift
//  User
//
//  Created by CSS on 08/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import Lottie

typealias LottieView = LOTAnimationView

class LottieHelper {


    func addHeart(with frame : CGRect)->LottieView{
        
        let heartView = LOTAnimationView(name: "heart")
        heartView.frame = frame
        return heartView
    }
    

}

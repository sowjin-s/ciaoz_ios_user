//
//  YourTripsViewController.swift
//  User
//
//  Created by CSS on 13/06/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class YourTripsDetailViewController: UITableViewController {
    
    @IBOutlet private weak var imageViewMap : UIImageView!
    @IBOutlet private weak var imageViewProvider : UIImageView!
    @IBOutlet private weak var labelProviderName : UILabel!
    @IBOutlet private weak var viewRating : FloatRatingView!
    @IBOutlet private weak var labelDate : UILabel!
    @IBOutlet private weak var labelTime : UILabel!
    @IBOutlet private weak var labelBookingId : UILabel!
    @IBOutlet private weak var labelPayViaString : UILabel!
    @IBOutlet private weak var imageViewPayVia : UIImageView!
    @IBOutlet private weak var labelPayVia : UILabel!
    @IBOutlet private weak var labelPrice : UILabel!
    @IBOutlet private weak var labelCommentsString : UILabel!
    @IBOutlet private weak var textViewComments : UITextView!
    @IBOutlet private weak var buttonCancelRide : UIButton!
    @IBOutlet private weak var buttonViewReciptAndCall : UIButton!
    @IBOutlet private weak var viewLocation : UIView!
    @IBOutlet private weak var labelSourceLocation : UILabel!
    @IBOutlet private weak var labelDestinationLocation : UILabel!
    @IBOutlet private weak var viewComments : UIView!
    
    var isUpcomingTrips = false  // Boolean to handle Past and Upcoming Trips
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    private var heightArray : [CGFloat] = [62,75,70,145]
    private var dataSource : Request?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
        self.localize()
        self.setDesign()
        let height = (self.buttonViewReciptAndCall.convert(self.buttonViewReciptAndCall.frame, to: UIApplication.shared.keyWindow ?? self.tableView).origin.y+self.buttonViewReciptAndCall.frame.height) 
        let footerHeight = UIScreen.main.bounds.height-height
        self.tableView.tableFooterView?.frame.size.height = footerHeight/2-(self.buttonViewReciptAndCall.frame.height)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        self.imageViewMap.image = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isUpcomingTrips {
        } else {
            self.viewLocation.removeFromSuperview()
        }
    }

}

// MARK:- Methods

extension YourTripsDetailViewController {
    
    // MARK:- Initial Loads
    private func initialLoads() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.buttonCancelRide.isHidden = !isUpcomingTrips
    }
    
    // MARK:- Localize
    private func localize() {
        
        self.buttonViewReciptAndCall.setTitle((isUpcomingTrips ? Constants.string.call:Constants.string.viewRecipt).localize().uppercased(), for: .normal)
        self.labelPayViaString.text = (isUpcomingTrips ? Constants.string.paymentMethod : Constants.string.payVia).localize()
        
        if isUpcomingTrips {
            self.buttonCancelRide.setTitle(Constants.string.cancelRide.localize().uppercased(), for: .normal)
        } else {
            self.labelCommentsString.text = Constants.string.comments.localize()
        }
        self.navigationItem.title = (isUpcomingTrips ? Constants.string.upcomingTripDetails : Constants.string.pastTripDetails).localize()
        
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
       Common.setFont(to: self.labelCommentsString, isTitle: true)
       Common.setFont(to: self.labelPayViaString, isTitle:  true)
       Common.setFont(to: self.labelDate)
       Common.setFont(to: self.labelTime)
       Common.setFont(to: self.labelBookingId)
       Common.setFont(to: self.labelPrice)
       Common.setFont(to: self.labelProviderName)
       Common.setFont(to: self.labelSourceLocation, size : 12)
       Common.setFont(to: self.labelDestinationLocation, size : 12)
       Common.setFont(to: self.labelPayVia)
       Common.setFont(to: self.buttonViewReciptAndCall, isTitle: true)
       if isUpcomingTrips {
            Common.setFont(to: self.buttonCancelRide, isTitle: true)
       }
    }
    
    
    // MARK:- Set values
    
    private func setValues() {
      
        let mapImage = self.dataSource?.static_map?.replacingOccurrences(of: "%7C", with: "|").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Cache.image(forUrl: Common.getImageUrl(for: mapImage)) { (image) in
            if image != nil {
                self.imageViewMap.image = image
            }
            
        }
        
    }
    
    
}

// MARK:- Postview Protocol

extension YourTripsDetailViewController: PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    
    func getRequestArray(api: Base, data: [Request]) {
        
        DispatchQueue.main.async {
            self.loader.isHidden = true
        }
        
        if data.count>0 {
            self.dataSource = data.first
        }
    }
    
    
}

//// MARK:- ScrollView Delegate
//
//extension YourTripsDetailViewController {
//
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        guard scrollView.contentOffset.y<0 else { return }
//
//        let inset = abs(scrollView.contentOffset.y/imageViewMap.frame.height)
//
//        self.imageViewMap.transform = CGAffineTransform(scaleX: 1+inset, y: 1+inset)
//
//    }
//
//}

extension YourTripsDetailViewController {
    
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
    if isUpcomingTrips && indexPath.row == 3 || !isUpcomingTrips && indexPath.row == 1 {
        return 0
    } else  {
         return heightArray[indexPath.row]
    }

    }
    
}




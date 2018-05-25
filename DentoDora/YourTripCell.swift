//
//  YourTripCell.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class YourTripCell: UITableViewCell {

    //MARK:- view outlets
    @IBOutlet var mainView: UIView!
    @IBOutlet var pastView: UIView!
    @IBOutlet var upComingView: UIView!
    
    //MARK:- UIimageView outLets
    @IBOutlet var upCommingCarImage: UIImageView!
    @IBOutlet var mapImageView: UIImageView!

    
    //MARK:- label outlets
    @IBOutlet var upCommingDateLabel: UILabel!
    @IBOutlet var upCommingBookingIDLlabel: UILabel!
    @IBOutlet var upCommingCarName: UILabel!
    @IBOutlet var bookingIdLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    //MARK:- button outlets
    @IBOutlet var upCommingCancelBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCommonFont()
        // Initialization code
    }
    
    private func setCommonFont(){
        
        setFont(TextField: nil, label: upCommingBookingIDLlabel, Button: nil, size: nil)
        setFont(TextField: nil, label: upCommingDateLabel, Button: upCommingCancelBtn, size: nil)
        setFont(TextField: nil, label: upCommingCarName, Button: nil, size: nil)
        setFont(TextField: nil, label: bookingIdLabel, Button: nil, size: nil )
        setFont(TextField: nil, label:nameLabel , Button: nil, size: nil)
        setFont(TextField: nil, label: dateLabel , Button: nil, size: nil)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

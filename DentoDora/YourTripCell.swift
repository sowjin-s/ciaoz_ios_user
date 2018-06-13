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
    //@IBOutlet var pastView: UIView!
    @IBOutlet var upComingView: UIView!
    
    //MARK:- UIimageView outLets
    @IBOutlet var upCommingCarImage: UIImageView!
    @IBOutlet var mapImageView: UIImageView!

    
    //MARK:- label outlets
    @IBOutlet var upCommingDateLabel: UILabel!
    @IBOutlet var upCommingBookingIDLlabel: UILabel!
    @IBOutlet var upCommingCarName: UILabel!
    /*@IBOutlet var bookingIdLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel! */
    
    //MARK:- button outlets
    @IBOutlet var upCommingCancelBtn: UIButton!
    @IBOutlet private var labelPrice : UILabel!
    @IBOutlet private var labelModel : UILabel!
    @IBOutlet private var stackViewPrice : UIStackView!
    
    var isPastButton = false {
        didSet {
            self.stackViewPrice.isHidden = !isPastButton
            self.upCommingCancelBtn.isHidden = isPastButton
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setDesign()
        self.upCommingCancelBtn.setTitle(Constants.string.cancelRide.localize(), for: .normal)
    }
    
    // MARK:- Set Font
    
    private func setDesign() {
        
        Common.setFont(to: upCommingDateLabel)
        Common.setFont(to: upCommingBookingIDLlabel)
        Common.setFont(to: upCommingCarName)
        Common.setFont(to: labelModel)
        Common.setFont(to: labelPrice)
        
    }
    
    // MARK:- Set Values
    
    func set(values : Request) {
        print(isPastButton)
        Cache.image(forUrl: values.service?.image) { (image) in
            if image != nil {
                self.upCommingCarImage.image = image
            }
        }
        
        let mapImage = values.static_map?.replacingOccurrences(of: "%7C", with: "|").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Cache.image(forUrl: mapImage) { (image) in
            if image != nil {
                self.mapImageView.image = image
            }
        }
        
        self.upCommingBookingIDLlabel.text = Constants.string.bookingId+": "+String.removeNil(values.booking_id)
        self.upCommingCarName.text = values.service?.name
        self.upCommingCarName.isHidden = isPastButton
        
        if let dateObject = Formatter.shared.getDate(from: isPastButton ? values.assigned_at : values.schedule_at, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss),
            let dateString = Formatter.shared.getString(from: dateObject, format: DateFormat.list.ddMMMyyyy),
            let timeString = Formatter.shared.getString(from: dateObject, format: DateFormat.list.hh_mm_a)
        {
            
            self.upCommingDateLabel.text = dateString+" \(Constants.string.at.localize()) "+timeString
        }
        if self.isPastButton {
            self.labelModel.text = values.service?.name
            self.labelPrice.text = "\(String.removeNil(User.main.currency)) \(Int.removeNil(values.payment?.total))"
        }
        
    }
    
    
    
//    private func setCommonFont(){
//        
//        setFont(TextField: nil, label: upCommingBookingIDLlabel, Button: nil, size: nil)
//        setFont(TextField: nil, label: upCommingDateLabel, Button: upCommingCancelBtn, size: nil)
//        setFont(TextField: nil, label: upCommingCarName, Button: nil, size: nil)
//        setFont(TextField: nil, label: bookingIdLabel, Button: nil, size: nil )
//        setFont(TextField: nil, label:nameLabel , Button: nil, size: nil)
//        setFont(TextField: nil, label: dateLabel , Button: nil, size: nil)
//        
//        
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

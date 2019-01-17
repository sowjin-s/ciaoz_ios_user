//
//  NotificationTableViewCell.swift
//  Provider
//
//  Created by Sravani on 08/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NotifImage: UIImageView!
    @IBOutlet weak var notifHeaderLbl: UILabel!
    @IBOutlet weak var notifContentLbl: UILabel!
    
    @IBOutlet weak var NitifView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.setdesign()
    }
    
    func setdesign() {
        self.NitifView.layer.borderWidth = 1.5
        self.NitifView.layer.borderColor = UIColor.gray.cgColor
        Common.setFont(to: notifHeaderLbl)
        Common.setFont(to: notifContentLbl)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


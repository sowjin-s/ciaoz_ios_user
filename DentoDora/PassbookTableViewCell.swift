//
//  PassbookTableViewCell.swift
//  User
//
//  Created by CSS on 25/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class PassbookTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var labelDate :UILabel!
    @IBOutlet private weak var labelAmountString :UILabel!
    @IBOutlet private weak var labelOffer :UILabel!
    @IBOutlet private weak var labelCredit :UILabel!
    @IBOutlet private weak var labelPaymentType :UILabel!
    @IBOutlet private weak var labelCouponStatus : UILabel!
    

    var isWalletSelected = true {
        didSet {
            self.labelCouponStatus.isHidden = isWalletSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

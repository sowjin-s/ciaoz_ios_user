    //
//  RatingView.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RatingView: UIView {

    @IBOutlet private weak var labelRating:UILabel!
    @IBOutlet private weak var imageViewProvider : UIImageView!
    @IBOutlet private weak var viewRating : FloatRatingView!
    @IBOutlet private weak var textViewComments : UITextView!
    @IBOutlet private weak var buttonSubmit : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    
}

extension RatingView {
    
    func initialLoads() {
       
        self.textViewComments.delegate = self
        textViewDidEndEditing(textViewComments)
        self.localize()
    }
    
    //MARK:- Localize
    
    private func localize() {
        
        self.labelRating.text = Constants.string.rateyourtrip.localize()
        self.buttonSubmit.setTitle(Constants.string.submit.localize(), for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imageViewProvider.makeRoundedCorner()
    }
    
}

    //MARK:- UITextViewDelegate
 extension RatingView : UITextViewDelegate {
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if textView.text == Constants.string.writeYourComments.localize() {
                textView.text = .Empty
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if textView.text == .Empty {
                textView.text = Constants.string.writeYourComments.localize()
                textView.textColor = .lightGray
            }
            
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            
            return true
        }}

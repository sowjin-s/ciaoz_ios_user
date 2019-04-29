//
//  CustomPicker.swift
//  blablacar
//
//  Created by Suganya on 28/02/19.
//  Copyright © 2019 Ranjith. All rights reserved.
//

import UIKit


class CustomPicker: UIView {
    
    @IBOutlet private weak var picker: UIPickerView!
    @IBOutlet private weak var toolBarView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    private var pickerArray: [userLocation] = []
    private var serviceArray: [Service] = []
    
    var isPostal: Bool? = false
    var pickedValue: (String?,Int?)
    var onClickDone: ((String?,Int?)->Void)?
    var onClickCancel: (()->Void)?
    
    override func awakeFromNib() {
      
        self.intialLoad()
        
    }
    

}

extension CustomPicker {
    
    private func intialLoad() {
     
        self.picker.delegate = self
        self.picker.dataSource = self
        self.picker.selectRow(0, inComponent: 0, animated: true)
        [self.picker,self.toolBarView].forEach { $0?.backgroundColor = .primary}
        self.doneButton.addTarget(self, action: #selector(self.done), for: .touchUpInside)
        self.cancelButton.addTarget(self, action: #selector(self.cancel), for: .touchUpInside)

    }
    
    func setPicker(with values: [userLocation]?,postal: Bool?) {
      
        self.isPostal = postal
        self.pickerArray = values!
        self.pickedValue.0 = pickerArray[0].name
        
    }
    
    @objc private func done() {
        
        self.onClickDone?(pickedValue.0,pickedValue.1)
        
    }
    
    @objc private func cancel() {
      
        self.onClickCancel?()
    }
    
    private func getRow(itemAt row: Int)-> String? {
        
        if isPostal! {
            return pickerArray[row].postalcode
        } else {
           return pickerArray[row].name
        }
    }
    
    private func getSelected(at row: Int)-> String? {
        if isPostal! {
            return pickerArray[row].postalcode
        } else {
            return pickerArray[row].name
        }
    
    }
}

extension CustomPicker : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getRow(itemAt: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedValue.0 = getSelected(at: row)
        pickedValue.1 = row
    }
    
}

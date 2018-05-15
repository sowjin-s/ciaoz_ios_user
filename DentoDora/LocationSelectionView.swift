//
//  LocationSelectionView.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import GooglePlaces

class LocationSelectionView: UIView {

    @IBOutlet private weak var viewTop : UIView!
    @IBOutlet private weak var tableViewBottom : UITableView!
    @IBOutlet private weak var viewBack : UIView!
    @IBOutlet private weak var textFieldSource : UITextField!
    @IBOutlet private weak var textFieldDestination : UITextField!
    @IBOutlet private weak var viewSourceCancel : UIView!
    @IBOutlet private weak var viewDestinationCancel : UIView!
  
    typealias Address = (source : Bind<LocationDetail>?,destination : LocationDetail?)
   
    private var completion : ((Address)->Void)? // On dismiss send address
    
    private var address : Address? // Current Address
    {
        didSet{
            if address?.source != nil {
                self.textFieldSource.text = self.address?.source?.value?.address
            }
            if address?.destination != nil {
                self.textFieldDestination.text = self.address?.destination?.address
            }
        }
    }
    
//    private var sections = 2 // show Favourite if no search text is entered
    
    private var googlePlacesHelper : GooglePlacesHelper?
    
    private var datasource = [GMSAutocompletePrediction]() {  // Predictions List
        didSet {
             DispatchQueue.main.async {
                print("Reloaded")
                self.tableViewBottom.reloadData()
             }
        }
    }
    
    typealias FavouriteLocation = (address :String,location :LocationDetail?)
    
    private var favouriteLocations = [FavouriteLocation]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
}


extension LocationSelectionView {
    
    
    private func localize() {
       
        self.textFieldSource.placeholder = Constants.string.source.localize()
        self.textFieldDestination.placeholder = Constants.string.destination.localize()
        
    }

    
    private func initialLoads() {
        
    /*    self.viewTop.alpha = 0
        self.viewBottom.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.viewTop.alpha = 1
        }) { (_) in
            self.viewBottom.isHidden = false
            self.viewBottom.show(with: .bottom, duration: 0.7, completion: nil)
        }  */
        self.localize()
        self.googlePlacesHelper = GooglePlacesHelper()
        self.tableViewBottom.isHidden = true
        self.viewTop.alpha = 0
      /*  self.viewTop.show(with: .top) {
            self.tableViewBottom.isHidden = false
            self.tableViewBottom.show(with: .bottom, duration: 0.2, completion: nil)
        }*/
        
        UIView.animate(withDuration: 0.2, animations: {
            self.viewTop.alpha = 1
        }) { _ in
            self.tableViewBottom.isHidden = false
            self.tableViewBottom.show(with: .bottom, duration: 0.2, completion: nil)
        }
        
        self.tableViewBottom.delegate = self
        self.tableViewBottom.dataSource = self
        self.textFieldSource.delegate = self
        self.textFieldDestination.delegate = self
        self.tableViewBottom.register(UINib(nibName: XIB.Names.LocationTableViewCell, bundle: nil), forCellReuseIdentifier:XIB.Names.LocationTableViewCell)
        self.tableViewBottom.register(UINib(nibName: XIB.Names.LocationHeaderTableViewCell, bundle: nil), forCellReuseIdentifier:XIB.Names.LocationHeaderTableViewCell)
        self.viewBack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.backButtonAction)))
        [self.viewSourceCancel, self.viewDestinationCancel].forEach({ $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clearButtonAction(sender:))))})

    }
    
    // MARK:- OnTap Clear Button
    @IBAction private func clearButtonAction(sender : UITapGestureRecognizer){
        
        guard let senderView = sender.view else { return }
        
        if senderView == viewSourceCancel {
            textFieldSource.text = nil
        } else {
            textFieldDestination.text = nil
        }
        self.datasource = []
    }
    
    func setValues(address : Address,favourites : [(String, LocationDetail?)], completion :@escaping (Address)->Void){
        
        self.address = address
        self.completion = completion
        self.favouriteLocations = favourites
        
    }
    
    
    @IBAction private func backButtonAction() {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.tableViewBottom.frame.origin.y = self.tableViewBottom.frame.height
            self.viewTop.frame.origin.y = -self.viewTop.frame.height
        }) { (_) in
            self.isHidden = true
            self.removeFromSuperview()
        }
        
    }
    
    
    private func getPredications(from string : String?){
        
        self.googlePlacesHelper?.getAutoComplete(with: string, with: { (predictions) in
            self.datasource = predictions
        })
        
    }
    
}


// MARK:- UITableViewDataSource, UITableViewDelegate

extension LocationSelectionView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.getCell(for: indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? (datasource.count>0 ? 0 : 60) : 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2 //datasource.count == 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (section == 0) ? (datasource.count>0 ? 0 : favouriteLocations.count) : datasource.count // && datasource.count==0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        self.select(at: indexPath)
        
    }
    
    // MARK:- Did Select at Indexpath
    
    private func select(at indexPath : IndexPath){
        
        if indexPath.section == 0 {
            
            if self.favouriteLocations[indexPath.row].location != nil {
                
                self.autoFill(with: self.favouriteLocations[indexPath.row].location)

            } else {
                
                self.googlePlacesHelper?.getGoogleAutoComplete(completion: { (place) in
                    
                    self.favouriteLocations[indexPath.row].location = (place.formattedAddress ?? .Empty, place.coordinate)
                    DispatchQueue.main.async {
                        self.tableViewBottom.reloadData()
                        self.autoFill(with: self.favouriteLocations[indexPath.row].location)
                    }
                    
                })
            }
        } else {
            
            self.autoFill(with: (datasource[indexPath.row].attributedFullText.string, LocationCoordinate(latitude: 0, longitude: 0)))
            
            if datasource.count > indexPath.row, let placeID = datasource[indexPath.row].placeID{
                
                GMSPlacesClient.shared().lookUpPlaceID(placeID) { (place, error) in
                    
                    if error != nil {
                        
                        self.make(toast: error!.localizedDescription)
                        
                    } else if let addressString = place?.formattedAddress, let coordinate = place?.coordinate{
                        
                        self.autoFill(with: (addressString,coordinate))
                    }
                    
                }
                
            }
            
        }
        
    }
    
    // MARK:- Auto Fill At
    
    private func autoFill(with location : LocationDetail?){ //, with array : [T]
        
        if textFieldSource.isEditing {
            self.address?.source?.value = location//array  array [indexPath.row].location
            self.address?.source = self.address?.source // Temporary fix to call didSet
        } else {
            self.address?.destination = location
        }
        
        if self.address?.source?.value != nil, self.address?.destination != nil {
            self.completion?(self.address!)
            self.backButtonAction()
        }
        
    }
    
    
    // MARK:- Get Table View Cell
    
    private func getCell(for indexPath : IndexPath)->UITableViewCell{
        
        if indexPath.section == 0 { // Favourite Locations
            
            if let tableCell = self.tableViewBottom.dequeueReusableCell(withIdentifier: XIB.Names.LocationHeaderTableViewCell, for: indexPath) as? LocationHeaderTableViewCell, favouriteLocations.count>indexPath.row {
            
                tableCell.textLabel?.text = favouriteLocations[indexPath.row].0.localize()
                tableCell.detailTextLabel?.text = favouriteLocations[indexPath.row].1?.address ?? Constants.string.addLocation.localize()
                return tableCell
            }
            
        } else  { // Predications
            
            if let tableCell = self.tableViewBottom.dequeueReusableCell(withIdentifier: XIB.Names.LocationTableViewCell, for: indexPath) as? LocationTableViewCell, datasource.count>indexPath.row{
                
                tableCell.textLabel?.attributedText = datasource[indexPath.row].attributedFullText
                tableCell.textLabel?.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 12) ?? UIFont.systemFont(ofSize: 12)
                return tableCell
            }
            
        }
        
        return UITableViewCell()
        
    }
    
    
}


extension LocationSelectionView : UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        return textField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.datasource = []
        self.getPredications(from: textField.text)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        guard let text = textField.text, !text.isEmpty else {
            self.datasource = []
            return true
        }
        
        let searchText = text+string
        
        guard searchText.count<50 else {
            return false
        }
        
        self.getPredications(from: searchText)
        
        print(textField.text, "  ", string, "   ", range.location, "  ", range.length)
        
        return true
        
    }

    
}

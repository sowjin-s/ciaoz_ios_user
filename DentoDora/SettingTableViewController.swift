//
//  SettingTableViewController.swift
//  User
//
//  Created by CSS on 25/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import PopupDialog

class SettingTableViewController: UITableViewController {
    
    private let tableCellId = "tableCellid"
    private let languageCellId = "LanguageSelection"
    private var numberOfRows = 2
    
    private let header = [Constants.string.favourites, Constants.string.changeLanguage]
    private let languages = [Language.english, .spanish]
    
    lazy var loader  : UIView = {
        return createActivityIndicator(self.view)
    }()
    
    private var selectedLanguage : Language = .english
    
    private var locationService : LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if let lang = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: lang) {
            selectedLanguage = language
        }
        self.initalLoads()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

//MARK:- Methods
extension SettingTableViewController {
    
    private func initalLoads() {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backButtonClick))
        self.navigationItem.title = Constants.string.settings.localize()
        self.presenter?.get(api: .locationService, parameters: nil)
        
    }
    
}



extension SettingTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.header.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.header[section] //section == 0 && numberOfRows == 0 ? Constants.string.noFavouritesFound.localize() :
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0, let tableCell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as? SettingTableCell {
            
            tableCell.imageViewIcon?.image = indexPath.row == 0 ? #imageLiteral(resourceName: "home") : #imageLiteral(resourceName: "work")
            tableCell.labelTitle.text = (indexPath.row == 0 ? Constants.string.home : Constants.string.work).localize()
            tableCell.labelAddress.text = {
                
                if indexPath.row == 0 {
                    return (locationService?.home?.first?.address) != nil ? (locationService?.home?.first?.address) : Constants.string.addLocation.localize()
                } else {
                    return (locationService?.work?.first?.address) != nil ? (locationService?.work?.first?.address) : Constants.string.addLocation.localize()
                }
                
            }()
            tableCell.selectionStyle = .none
            return tableCell
        } else if indexPath.section == 1, let tableCell = tableView.dequeueReusableCell(withIdentifier: languageCellId, for: indexPath) as? LanguageSelection {
            
            tableCell.labelTitle.text = self.languages[indexPath.row].rawValue.localize()
            tableCell.imageViewIcon.image = self.selectedLanguage == self.languages[indexPath.row] ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "check-box-empty")
            tableCell.selectionStyle = .none
            return tableCell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? numberOfRows : Language.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let popDialog = PopupDialog(title: Constants.string.areYouSure.localize(), message: nil)
            let cancelButton =  PopupDialogButton(title: Constants.string.Cancel.localize(), action: {
                popDialog.dismiss()
            })
            cancelButton.titleColor = .primary
            let sureButton = PopupDialogButton(title: Constants.string.delete.localize()) {
                
                guard let idValue = indexPath.row == 0 ? self.locationService?.home?.first?.id : self.locationService?.work?.first?.id else { return }
                
                self.loader.isHidden = false
                self.presenter?.delete(api: .locationServicePostDelete, url: Base.locationServicePostDelete.rawValue+"/\(idValue)", data: nil)
                
            }
            sureButton.titleColor = .red
            popDialog.addButtons([sureButton,cancelButton])
            self.present(popDialog, animated: true, completion: nil)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 && (locationService?.home?.first?.address) != nil {
                return .delete
            }
            if indexPath.row == 1 && (locationService?.work?.first?.address) != nil {
                return .delete
            }
        }
        
        return .none
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (indexPath.section == 0 ? 100 : 40 )*(UIScreen.main.bounds.height/568)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            self.selectedLanguage = languages[indexPath.row]
            UserDefaults.standard.set(self.selectedLanguage.rawValue, forKey: Keys.list.language)
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1),IndexPath(row: 1, section: 1)], with: .automatic)
        } else if indexPath.section ==  0{
            
            GooglePlacesHelper().getGoogleAutoComplete { (place) in
                GoogleMapsHelper().getPlaceAddress(from: place.coordinate, on: { (locationDetail) in
                    var service = Service() // Save Favourite location in Server
                    service.address = place.formattedAddress
                    service.latitude = place.coordinate.latitude
                    service.longitude = place.coordinate.longitude
                    service.type = indexPath.row == 0 ? Constants.string.home : Constants.string.work
                    self.presenter?.post(api: Base.locationServicePostDelete, data: service.toData())
                    
                })
            }
        }
    }
    
}

// MARK:- PostViewProtocol

extension SettingTableViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getLocationService(api: Base, data: LocationService?) {
//
//        if data != nil {
//            numberOfRows = 0
//            if let _ = data?.home?.first {
//              numberOfRows += 1
//            }
//
//            if let _ = data?.work?.first {
//                numberOfRows += 1
//            }
//        }
//
        
        storeFavouriteLocations(from: data)
        self.locationService = data
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.tableView.reloadData()
        }
        
    }
    
    func success(api: Base, message: String?) {
        
        if api == .locationServicePostDelete {
            self.presenter?.get(api: .locationService, parameters: nil)
        }
    }
    
}


class SettingTableCell : UITableViewCell {
    
    @IBOutlet var labelTitle : UILabel!
    @IBOutlet var labelAddress : UILabel!
    @IBOutlet var imageViewIcon : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView?.contentMode = .scaleAspectFit
    }
    
}

class LanguageSelection : UITableViewCell {
    
    @IBOutlet var labelTitle : UILabel!
    @IBOutlet var imageViewIcon : UIImageView!
    
}

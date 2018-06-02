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
    private var numberOfRows = 2
    
    private let header = [Constants.string.favourites, Constants.string.changeLanguage]
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    }
    
}



extension SettingTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.header.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.header[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as? SettingTableCell {
            
            tableCell.imageViewIcon?.image = indexPath.row == 0 ? #imageLiteral(resourceName: "home") : #imageLiteral(resourceName: "work")
            return tableCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? numberOfRows : Language.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let popDialog = PopupDialog(title: Constants.string.areYouSure.localize(), message: nil)
            let cancelButton =  PopupDialogButton(title: Constants.string.Cancel.localize(), action: {
                popDialog.dismiss()
            })
            cancelButton.titleColor = .primary
            let sureButton = PopupDialogButton(title: Constants.string.delete.localize()) {
                self.numberOfRows-=1
                self.tableView.reloadData()
            }
            sureButton.titleColor = .red
            popDialog.addButtons([sureButton,cancelButton])
            self.present(popDialog, animated: true, completion: nil)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100*(UIScreen.main.bounds.height/568)
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

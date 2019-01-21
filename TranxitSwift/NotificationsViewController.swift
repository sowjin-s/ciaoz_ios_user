//
//  NotificationsViewController.swift
//  Provider
//
//  Created by Sravani on 08/01/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    
    var dataSource : [NotificationManagerModel]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.SetNavigationcontroller()
        self.presenter?.get(api: .notificationManager, parameters: nil)
    }
    
    func SetNavigationcontroller(){
        
        if #available(iOS 11.0, *) {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.prefersLargeTitles = false
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = Constants.string.notifications.localize()
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(self.backBarButtonTapped(button:)))
    }
    
    @IBAction func backBarButtonTapped(button: UINavigationItem){
        self.popOrDismiss(animation: true)
    }
    
}

// Mark : Tableview delegates methods

extension NotificationsViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
        cell.notifHeaderLbl.text = self.dataSource?[indexPath.section].notify_type
        cell.notifContentLbl.text = self.dataSource?[indexPath.section].description
        cell.NotifImage.setImage(with: self.dataSource?[indexPath.section].image, placeHolder: #imageLiteral(resourceName: "CarplaceHolder"))
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
   
}

extension NotificationsViewController : PostViewProtocol {
  
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getNotificationsMangerList(api: Base, data: [NotificationManagerModel]?) {
       
        if api == .notificationManager {
            print(data!)
            dataSource = data
            self.tableView.reloadData()
            
        }
    }
    
    
}


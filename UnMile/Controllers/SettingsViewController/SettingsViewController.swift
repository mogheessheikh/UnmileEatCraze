//
//  SettingsViewController.swift
//  UnMile
//
//  Created by Adnan Asghar on 2/7/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController {

    var userSettingArray = ["User Profile", "Delivery Address", "Update Password","Contact Spport", "About Us", "Logout"]
    var UserSettingLogos: [UIImage] = [UIImage(named: "user-1")!, UIImage(named: "location1")!,UIImage(named: "lock")!, UIImage(named: "support")!,UIImage(named: "info")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

   
}
extension SettingsViewController: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserDefaults.standard.object(forKey: "userName") != nil{
            return userSettingArray.count
        }
        else {return 1}
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingsCell
            else {
                fatalError("Unknown cell")
        }
        if UserDefaults.standard.object(forKey: "userName") != nil{
            cell.settingLbl.text = userSettingArray[indexPath.row]
            cell.settingLogo.image = UserSettingLogos[indexPath.row]
            return cell
        }
        else{
            cell.settingLbl.text = "Login/Registration"
            return cell
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if UserDefaults.standard.object(forKey: "userName") == nil{
            if indexPath.section == 0 && indexPath.row == 0 {
                
                let loginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identifier)
                loginVC.title = "Signin"
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    
}

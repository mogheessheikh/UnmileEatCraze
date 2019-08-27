//
//  EatCrazeSettingVC.swift
//  UnMile
//
//  Created by iMac on 12/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class EatCrazeSettingVC: BaseViewController {
    
    
    var userSettingArray = ["User Profile", "Delivery Address", "Update Password","Contact Spport", "About Us", "Logout"]
    var UserSettingLogos: [UIImage] = [UIImage(named: "user-1")!, UIImage(named: "location1")!,UIImage(named: "lock")!, UIImage(named: "support")!,UIImage(named: "info")!,UIImage(named: "info")!]
    
    @IBOutlet var tblSettings: UITableView!
    
    override func viewDidLoad() {
          super.viewDidLoad()

    }

}
extension EatCrazeSettingVC: UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if UserDefaults.standard.object(forKey: "customerName") != nil{
            return userSettingArray.count
        }
        else {return 1}
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingcell", for: indexPath) as? EatCrazeSettingCell
            else {
                fatalError("Unknown cell")
        }
        if UserDefaults.standard.object(forKey: "customerName") != nil{
            cell.settingLbl.text = userSettingArray[indexPath.row]
            cell.settingLogo.image = UserSettingLogos[indexPath.row]
            return cell
        }
        else{
            cell.settingLbl.text = "Login/Registration"
            cell.settingLogo.image = UIImage(named: "user-1")
            return cell
    
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if UserDefaults.standard.object(forKey: "customerName") == nil{
            if indexPath.section == 0 && indexPath.row == 0 {
    
                let loginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identifier)
                loginVC.title = "Signin"
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
        else{
            if(indexPath.row == 0){
                performSegue(withIdentifier: "settings2subsetting", sender: self)
            }
            
            if (indexPath.row == 5)
            {
                logOutAlert(title: "Do You Want to LogOut?", message: "You will not able to place any oder",dataTable: tblSettings )  
            }
            
            
        }
    
        
    }
    
    
}


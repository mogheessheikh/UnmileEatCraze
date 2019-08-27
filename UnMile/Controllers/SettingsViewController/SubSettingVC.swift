//
//  SubSettingVC.swift
//  UnMile
//
//  Created by iMac on 12/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class SubSettingVC: UIViewController {
    
    @IBOutlet var tblSubSettings: UITableView!
    var userArray: [String] = ["First Name", "Last Name", "Email", "Phone"]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tblSubSettings.register(UINib(nibName: "UserInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "userinfocell")
        // Do any additional setup after loading the view.
    }

}
extension SubSettingVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userinfocell", for: indexPath) as? UserInfoCell
            else {
                fatalError("Unknown cell")
        }
        if UserDefaults.standard.object(forKey: "userName") != nil {
           let username = UserDefaults.standard.object(forKey: "userName")
            cell.txtuserInfo.placeholder = username as? String
        }
        cell.lblUserInfo.text = userArray[indexPath.row]
        
        
        return cell
    }
    
    
    
    
}

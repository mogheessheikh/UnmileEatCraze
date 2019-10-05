//
//  ContainerVC.swift
//  UnMile
//
//  Created by iMac  on 18/06/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class ContainerVC: BaseViewController {
    
    
    @IBOutlet weak var sideMenuConstraints: NSLayoutConstraint!
    
    var sideMenuOpen = false
    var menuItems = ["Login","Create Account","Search By Map","Search By Area", "Live Chat","Share","Feed Back" ,"Term and Condition"]
    var menuLogOut = ["LogOut","Create Account","Search By Map","Search By Area", "Live Chat","Share","Feed Back" ,"Term and Condition"]
    var section1 = ["User Profile", "Delivery Address", "Update Password"]
    
    var menuItemImg: [UIImage] = [UIImage(named: "SLOGIN")! , UIImage(named: "Screate account")!,UIImage(named: "Slocation")!,UIImage(named: "Shome")!, UIImage(named: "Schat")!, UIImage(named: "Sshare")!, UIImage(named: "Sfeedback")!, UIImage(named: "Stermsandcondition")!]
    
    var section1Img: [UIImage] = [UIImage(named: "Suser")!,UIImage(named: "Slocation")! ,UIImage(named: "Spassword")!]
    
    var menuLogOutItemImg: [UIImage] = [UIImage(named: "Slogout")! , UIImage(named: "Screate account")!,UIImage(named: "Slocation")!,UIImage(named: "Shome")!, UIImage(named: "Schat")!, UIImage(named: "Sshare")!, UIImage(named: "Sfeedback")!, UIImage(named: "Stermsandcondition")!]
    
    var registeredUser = ""
    var myCustomView: UIImageView!
    
    @IBOutlet weak var tblSlideMenu: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

}
extension ContainerVC : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        if UserDefaults.standard.object(forKey: "customerName") != nil{
        return 2
        }
        else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.object(forKey: "customerName") != nil{
            if(section == 0)
            {
                return 3
            }
            else {
                return menuItems.count
            }
       
        }
        else{
            return menuLogOut.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SideMenuCell else {
            fatalError("Unknown cell")
        }
         if UserDefaults.standard.object(forKey: "customerName") != nil{
            if(indexPath.section == 0)
            {
                cell.lblSideMenu.text = section1[indexPath.row]
                cell.imgSideMenu.image = section1Img[indexPath.row]
            }
            else {
                cell.lblSideMenu.text =  menuLogOut[indexPath.row]
                cell.imgSideMenu.image = menuLogOutItemImg[indexPath.row]
            }
        }
         else{
            cell.lblSideMenu.text = menuItems[indexPath.row]
            cell.imgSideMenu.image = menuItemImg[indexPath.row]
            
        }
     return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
    
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 { return 70}
    
    return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // checking if user is logIn
        
        if UserDefaults.standard.object(forKey: "customerName") == nil{
        if indexPath.row == 0 {
            
            let loginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: LoginViewController.identifier)
            loginVC.title = "Signin"
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        else if (indexPath.row == 1)
        {
            let userCreateAccount = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "UserRegistrationVC")
            userCreateAccount.title = "Create Account"
            self.navigationController?.pushViewController(userCreateAccount, animated: true)
        }
        else if (indexPath.row == 2)
        {
            showAlert(title: "Beta Version Exception", message: "Dear customer this feature will be available in Upgrated version")
        }
        else if (indexPath.row == 3)
        {
            showAlert(title: "Beta Version Exception", message: "Dear customer this feature will be available in Upgrated version")
        }
        else if (indexPath.row == 4)
        {
            showAlert(title: "Beta Version Exception", message: "Dear customer this feature will be available in Upgrated version")
        }
        else if (indexPath.row == 5)
        {
            let text = "Share EatCraze"
            let myWebsite : NSURL = NSURL(string: "https://apps.apple.com/us/app/eat-craze/id1444723136")!
            // If you want to put an image
            let image : UIImage = UIImage(named: "logo.png")!
            
            let shareAll : [Any] = [text , image , myWebsite]
            
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
            
            
        }
        else if (indexPath.row == 6)
        {
            let feedBack = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackVC")
            self.navigationController?.pushViewController(feedBack, animated: true)
            
            }
        }
            
            
            //if user is not login then given functionalities to sideMenu Items
            
            
            
          else if (indexPath.section == 0 && indexPath.row == 0)
        {
            let userProfile = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubSettingVC")
            userProfile.title = "User Profile"
            self.navigationController?.pushViewController(userProfile, animated: true)
        }
            
        else if (indexPath.section == 0 && indexPath.row == 1)
        {
            let userAddress = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC")
            userAddress.title = "User Address"
            self.navigationController?.pushViewController(userAddress, animated: true)
        }
        else if (indexPath.section == 0 && indexPath.row == 2)
        {
            let userUpdatePassword = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "ForgotPasswordViewController")
            userUpdatePassword.title = "Update Password"
            self.navigationController?.pushViewController(userUpdatePassword, animated: true)
        }
            
        else if (indexPath.section == 1 && indexPath.row == 0)
        {
            logOutAlert(title: "Do You Want to LogOut?", message: "You will not able to place any order",dataTable: tblSlideMenu )
        }
        else if (indexPath.section == 1 && indexPath.row == 1)
        {
            let userCreateAccount = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "UserRegistrationVC")
            userCreateAccount.title = "Create Account"
            self.navigationController?.pushViewController(userCreateAccount, animated: true)
        }
        else if (indexPath.section == 1 && indexPath.row == 2)
        {
           showAlert(title: "Beta Version Exception", message: "Dear customer this feature will be available in Upgrated version")
        }
        else if (indexPath.section == 1 && indexPath.row == 3)
        {
            showAlert(title: "Beta Version Exception", message: "Dear customer this feature will be available in Upgrated version")
        }
        else if (indexPath.section == 1 && indexPath.row == 4)
        {
            showAlert(title: "Beta Version Exception", message: "Dear customer this feature will be available in Upgrated version")
        }
        else if (indexPath.section == 1 && indexPath.row == 5)
        {
            let text = "Share EatCraze"
            let myWebsite : NSURL = NSURL(string: "https://apps.apple.com/us/app/eat-craze/id1444723136")!
            // If you want to put an image
            let image : UIImage = UIImage(named: "logo.png")!
            
            let shareAll : [Any] = [text , image , myWebsite]
            
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            
            present(activityViewController, animated: true, completion: nil)
        
        
    }
        else if (indexPath.section == 1 && indexPath.row == 6)
        {
            let feedBack = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FeedBackVC")
            self.navigationController?.pushViewController(feedBack, animated: true)
            
        }
        
        else if (indexPath.section == 1 && indexPath.row == 7)
        {
            let feedBack = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Terms_Conditions") as! Terms_Conditions
            self.navigationController?.pushViewController(feedBack, animated: true)
            
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("SideMenuHeaderViewCell", owner: self, options: nil)?.first as! SideMenuHeaderViewCell
        
         if UserDefaults.standard.object(forKey: "SavedCustomer") != nil{
            customerCheck = getCustomerObject("SavedCustomer")
        }
        if customerCheck != nil  {
            headerView.imgHeader.image = UIImage(named: "user-1")!
            headerView.lblUserName.text = customerCheck.firstName
            headerView.lblUserEmail.text = customerCheck.email
    }
        else{
            headerView.lblUserName.text = "User is Not LogIn"
             headerView.lblUserEmail.text = ""
        }
     return headerView
}
}


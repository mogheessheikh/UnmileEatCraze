//
//  LoginViewController.swift
//  Eduhkmit
//
//  Created by Adnan Asghar on 8/30/18.
//  Copyright © 2018 Adnan. All rights reserved.

import UIKit
import Alamofire

protocol LoginDelegate {
    func userDidLogin()
}

class LoginViewController: BaseViewController {

    var loginDelegate: LoginDelegate?

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var userDataArray = [String]()
    
   
//    var isFrom = LoginIsFrom.Intro

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }

    @IBAction func loginDidPress(_ sender: UIButton) {
        
        // Read values from text fields
        let email = usernameField.text
        let password = passwordField.text
        
        // Check if required fields are not empty
        if (usernameField.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Username is required")
        } else if (passwordField.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Password is required")
        } else {
            //Send HTTP Request to perform Sign in
            
            login(email!, password!)
            
        }
    }
    func login(_ email:String, _ psw:String){
        startActivityIndicator()
        
        let URL_USER_LOGIN = Path.customerUrl+"/find-customer-id-companyid?email=\(email)&customerType=MEMBER&companyID=\(companyId)"
        
        let parameters: Parameters=[
            "userName":usernameField.text!,
            "userPassword":passwordField.text!
        ]
        
        //making a post request
        Alamofire.request(URL_USER_LOGIN, method: .get, parameters: parameters).responseJSON
            {
                response in
                //printing response
                print(response)
                
                //getting the json value from the server
                if let result = response.result.value {
                    let anItem = result as! NSDictionary
                    
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: anItem, options: .prettyPrinted)
                            // here "jsonData" is the dictionary encoded in JSON data
                            let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                            let jsonData1 = encodedObjectJsonString.data(using: .utf8)
                            
                            let customer = try! JSONDecoder().decode(CustomerDetail.self, from: jsonData1!)
                            if(email == customer.email && psw == customer.password )
                            {
                                self.stopActivityIndicator()
                                UserDefaults.standard.setValue(customer.firstName, forKey: "customerName")
                                UserDefaults.standard.set(customer.id, forKey: "customerId")
                                //self.saveCustomerObj(obj: customer, key: "savedCustomer" )
                                self.getUserDetail()
                                //switching the screen
                                if let tabbarVC = Storyboard.main.instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController,
                                    let nvc = tabbarVC.viewControllers?[0] as? UINavigationController,
                                    let _ = nvc.viewControllers[0] as? MainVC {
  
                                    UIApplication.shared.keyWindow!.replaceRootViewControllerWith(tabbarVC, animated: true, completion: nil)
                                }
                                
                                
                                self.dismiss(animated: false, completion: nil)
                                
                            }
                            else{
                                self.stopActivityIndicator()
                                self.showAlert(title: "Can't Find You in DataBase", message: "Make sure your  email or password is correct")
                            }
                            
                        } catch {
                            self.stopActivityIndicator()
                            print(error.localizedDescription)
                        }
                }
        }
        
        
    }
    
    @IBAction func registerDidPress(_ sender: UIButton) {
       
//        guard let registerVC =  UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "UserRegistrationVC ") as? UserRegistrationVC  else {
//            fatalError("Invalid Controller ")
//        }
//        self.navigationController?.pushViewController(registerVC, animated: true)
//
  }
}

struct CustomerDetail: Codable {
    let id: Int
    let customerType, ipAddress: String
    let internalInfo, salutation: String?
    let phone: String
    let mobile: String
    let firstName, lastName, email, password: String
    let salt: String
    let promotionSMS, promotionEmail: Bool?
    let registrationDate: String
    let companyID: Int
    let branchID: Int?
    let status: Int
    let addresses: [Address]
    
    enum CodingKeys: String, CodingKey {
        case id, customerType, ipAddress, internalInfo, salutation, phone, mobile, firstName, lastName, email, password, salt
        case promotionSMS = "promotionSms"
        case promotionEmail, registrationDate
        case companyID = "companyId"
        case branchID = "branchId"
        case status, addresses
    }
}

struct Address: Codable {
    let id, isDefault, archive: Int
    let addressFields: [AddressField]
}

struct AddressField: Codable {
    let id: Int
    let fieldName: String
    let label: String
    let fieldValue: String
}

//enum FieldName: String, Codable {
//    case addressLine1 = "addressLine1"
//    case addressLine2 = "addressLine2"
//    case area = "area"
//    case city = "city"
//}

//Adnan LoginCode
//NetworkManager.login(username: usernameField.text!, password: passwordField.text!, success: { (json, isError) in
////
////                if let success = json["userdata"]["data"]["success"].bool,
////                    success == true,
////                    let userId = json["userdata"]["data"]["0"][0]["ID"].string,
////                    let userEmail = json["userdata"]["data"]["0"][0]["user_email"].string,
////                    let userName = json["userdata"]["data"]["0"][0]["fullname"].string,
////                    let qCode = json["userdata"]["data"]["0"][0]["q_code"].string,
////                    let userStatus = json["userdata"]["data"]["0"][0]["user_status"].string,
////                    let userLogin = json["userdata"]["data"]["0"][0]["user_login"].string,
////                    let token = json["userdata"]["data"]["0"][0]["user_token"].string {
////
////                    if token.count > 0 {
////
////                        UserDefaults.standard.setValue(userId, forKey: "userId")
////                        UserDefaults.standard.setValue(userEmail, forKey: "userEmail")
////                        UserDefaults.standard.setValue(userLogin, forKey: "userLogin")
////                        UserDefaults.standard.setValue(userName, forKey: "userName")
////                        UserDefaults.standard.setValue(userStatus, forKey: "userStatus")
////                        UserDefaults.standard.setValue(token, forKey: "AccessToken")
////                        UserDefaults.standard.setValue(qCode, forKey: "qCode")
////                        UserDefaults.standard.synchronize()
////
////                        if let fcm = UserDefaults.standard.value(forKey: UserDefaultKeys.FirebaseRegistrationToken) as? String,
////                            fcm != "" {
////                            (UIApplication.shared.delegate as? AppDelegate)?.saveFCMDeviceToken(fcmTken: fcm, email: userEmail, userId: userId)
////                        }
////
////                        if self.isFrom == .Intro {
////                        DispatchQueue.main.async {
////                            let tabbarViewController = UIStoryboard.main.instantiateViewController(withIdentifier: "MainTabbarController")
////                            UIApplication.shared.keyWindow!.replaceRootViewControllerWith(tabbarViewController, animated: true, completion: nil)
////                            }
////                        } else if self.isFrom == .MyAccount {
////                            self.navigationController?.popViewController(animated: true)
////                        } else if self.isFrom == .RegisterEvent {
////                            self.loginDelegate?.userDidLogin()
////                            self.navigationController?.popViewController(animated: true)
////                        }
//////                    } else {
//////                        self.showError()
//                    }
//                } else if let error = json["userdata"]["data"]["0"].string {
//                    self.showAlert(title: "Error!", message: error)
////                } else {
////                    self.showError()
//                }
//            }, failure: { (error) in
////                self.showError()
//            })

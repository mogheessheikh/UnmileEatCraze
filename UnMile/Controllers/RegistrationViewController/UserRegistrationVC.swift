//
//  UserRegistrationVC.swift
//  UnMile
//
//  Created by iMac on 13/03/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import Alamofire

class UserRegistrationVC: BaseViewController {
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func registerButtonTapped(_ sender: Any) {
        if (firstName.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "First name is required")
        return
        } else if (lastName.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Last name is required")
        return
        } else if (emailField.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Email is required")
        return
        } else if !(emailField.text?.isValidEmail())! {
            showAlert(title: Strings.error, message: "Email is invalid")
        return
        } else if (passwordField.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Password is required")
        return
        } else if (phoneNumber.text?.isEmpty)! {
            showAlert(title: Strings.error, message: "Phone number is required")
        return
        }
        else{
            
            var email = emailField.text
            
            checkEmail(email!)
    }
    }
    
    func checkEmail(_ email:String ){
        startActivityIndicator()
        
        let URL_USER_LOGIN = "http://35.243.235.232:8082/rest/customer/find-customer-id-companyid?email=\(email)&customerType=MEMBER&companyID=52"
        
        let parameters: Parameters=[
            "userName":emailField.text!,
            "userPassword":passwordField.text!
        ]
        
        
        // let postString = ["userName": name, "userPassword": password] as [String: String]
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
                        
                        let customer = try? JSONDecoder().decode(CustomerDetail.self, from: jsonData1!)
                    
                        
                        if(email == customer!.email)
                        {
                            self.stopActivityIndicator()
                            
                            self.showAlert(title: "User Already Registered", message: "user is already registerd with this email \(email)")
                        }
                        
                        
                    } catch {
                        self.stopActivityIndicator()
                        print(error.localizedDescription)
                    }
                }
                    // if response.result.value found nil then registrationNewUser Called
                else{
                    self.registerNewUser()
                    
                    
                }
        }
        
        
    }
    
    
    func registerNewUser() {
        
        let registrationDate = currentDateTime()
        let ipAddress = getDeviceIP()
        
        let myUrl = URL(string: Path.customerUrl + "/create")
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["companyId":companyId,
                          "customerType":"MEMBER",
                          "firstName": firstName.text!,
                          "internalInfo":"",
                          "ipAddress": ipAddress,
                          "lastName": lastName.text!,
                          "email": emailField.text!,
                          "password": passwordField.text!,
                          "phone": phoneNumber.text!,
                          "mobile": phoneNumber.text!,
                          "promotionEmail":"false",
                          "promotionSms":"false",
                          "registrationDate": registrationDate,
                          "salt":"",
                          "salutation":"",
                          "status":1,
                          ] as [String: Any]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString , options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            showAlert(title: "Alert", message: "Something went wrong. Try again.")
            return
        }
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil
            {
                self.showAlert(title: "Request Error", message: "Could not successfully perform this request. Please try again later")
                
                print("error=\(String(describing: error))")
                return
            }
            
            // Let's convert response sent from a server side code to a NSDictionary object:
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    DispatchQueue.main.async {
                    let userId = parseJSON["firstName"] as? String
                    print("User id: \(String(describing: userId!))")
                    
                    if (userId?.isEmpty)!
                    {
                        // Display an Alert dialog with a friendly error message
                        self.showAlert(title: "Request Error", message: "Could not successfully perform this request. Please try again later")
                        return
                    } else {
                        self.showAlert(title: "SignIn Successfully", message: "Successfully Registered a New Account. Please proceed to Sign in")
                        
                    }
                    
                    }
                    
                }
                else {
                    //Display an Alert dialog with a friendly error message
                    //                        self.showAlert(title: "Request Error", message: "Could not successfully perform this request. Please try again later")
                    
                }
            } catch {
                
                // self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
                // Display an Alert dialog with a friendly error message
                self.showAlert(title: "Request Error", message: "Could not successfully perform this request. Please try again later")
                
                print(error)
            }
        }
        
        task.resume()
    }
    
    
    func currentDateTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    func getDeviceIP() -> String{
        
        var temp = [CChar](repeating: 0, count: 255)
        enum SocketType: Int32 {
            case  SOCK_STREAM = 0, SOCK_DGRAM, SOCK_RAW
        }
        gethostname(&temp, temp.count)
        
        var port: UInt16 = 0;let hosts = ["localhost", String(cString: temp)]
        var hints = addrinfo();hints.ai_flags = 0;hints.ai_family = PF_UNSPEC
        
        for host in hosts {
            print("\n\(host)")
            print()
            var info: UnsafeMutablePointer<addrinfo>?
            defer {
                if info != nil
                {
                    freeaddrinfo(info)
                }
            }
            let status: Int32 = getaddrinfo(host, String(port), nil, &info)
            guard status == 0 else {
                print(errno, String(cString: gai_strerror(errno)))
                continue
            }
            var p = info;var i = 0;var ipFamily = "";_ = ""
            
            while p != nil {
                i += 1
                let _info = p!.pointee
                p = _info.ai_next
                
                switch _info.ai_family {
                case PF_INET:
                    _info.ai_addr.withMemoryRebound(to: sockaddr_in.self, capacity: 1, { p in
                        inet_ntop(AF_INET, &p.pointee.sin_addr, &temp, socklen_t(temp.count))
                        ipFamily = "IPv4"
                    })
                case PF_INET6:
                    _info.ai_addr.withMemoryRebound(to: sockaddr_in6.self, capacity: 1, { p in
                        inet_ntop(AF_INET6, &p.pointee.sin6_addr, &temp, socklen_t(temp.count))
                        ipFamily = "IPv6"
                    })
                default:
                    continue
                }
                
                print(i,"\(ipFamily)\t\(String(cString: temp))", SocketType(rawValue: _info.ai_socktype)!)
                
            }
            
            
        }
        
        return String(cString: temp)
        
    }
    
}

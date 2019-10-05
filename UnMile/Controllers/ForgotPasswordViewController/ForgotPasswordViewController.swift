//
//  ForgotPasswordViewController.swift
//  Eduhkmit
//
//  Created by Adnan Asghar on 10/8/18.
//  Copyright © 2018 Adnan. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var retypePassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    var userData: CustomerDetail!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getUser()
    }
    
    @IBAction func resetDidPress(_ sender: UIButton) {
        if (newPassword.text!.isEmpty || retypePassword.text!.isEmpty){
                    showAlert(title: Strings.error, message: "Enter New Password to update")
                } else if (newPassword.text != retypePassword.text) {
                    showAlert(title: Strings.error, message: "Retyped password is not equal to new password")
                }
                else {
                    let password = newPassword.text
            let path = URL(string: Path.customerUrl + "/update-password")!
            let parameters =   ["id":userData!.id,
                                "customerType": "\(userData!.customerType)",
                "ipAddress": "\(userData!.ipAddress)",
                "internalInfo": "",
                "salutation": "",
                "phone": "\(userData.phone)",
                "mobile": "\(userData.mobile)",
                "firstName": "\(userData.firstName)",
                "lastName": "\(userData.lastName)",
                "email": "\(userData.email)",
                "salt": "",
                "promotionSMS": false,
                "promotionEmail":  false,
                "registrationDate": "\(userData!.registrationDate)",
                "status": userData!.status,
                "password": password!,
                "branchId": userData?.branchID,
                "addresses": [],
                "companyId": userData!.companyID
                ] as [String:Any]
            
            var request = URLRequest(url: path)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
            request.httpBody = httpBody
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let response = response {
                    print(response)
                }
                if let httpResponse = response as? HTTPURLResponse {
                    print("error \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200{
                if let data = data {
                    do {
                       
                        DispatchQueue.main.async {
                        
                                restResponse = true
                                self.stopActivityIndicator()
                                self.newPassword.text = ""
                                self.retypePassword.text = ""
                                self.showAlert(title: "Request Completed", message: "")
                            }
                        
                        }
                    catch {
                        print(error)
                    }
                        }
                    } else
                    {
                        self.stopActivityIndicator()
                        self.showAlert(title: "Request Decline", message: "Something goes worng")
                    }
                }
                
                }.resume()
            
    }
        
    }
    
    
    func getUser() {
        self.startActivityIndicator()
        if let Id = UserDefaults.standard.object(forKey: "customerId") as? Int{
            customerId = Id
            let path = URL(string: Path.customerUrl + "/\(customerId)")
            let session = URLSession.shared
            let task = session.dataTask(with: path!) { data, response, error in
                print("Task completed")
                
                guard data != nil && error == nil else {
                    print(error?.localizedDescription)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    if let parseJSON = json {
                        
                        let jsonData = try JSONSerialization.data(withJSONObject: parseJSON, options: .prettyPrinted)
                        let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                        let jsonData1 = encodedObjectJsonString.data(using: .utf8)
                        self.userData = try JSONDecoder().decode(CustomerDetail.self, from: jsonData1!)
                        DispatchQueue.main.async {
                           
                            self.stopActivityIndicator()
                        }
                        
                    }
                    
                } catch let parseError as NSError {
                    print("JSON Error \(parseError.localizedDescription)")
                }
            }
            
            task.resume()
        }
    }
    
}

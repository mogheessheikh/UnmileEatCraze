//
//  SubSettingVC.swift
//  UnMile
//
//  Created by iMac on 12/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class SubSettingVC: BaseViewController {
    
    @IBOutlet var tblSubSettings: UITableView!
    var userArray: [String] = ["First Name", "Last Name", "Email", "Phone"]
    var userData : CustomerDetail?
    var userDataArray: [String]?

    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    
    @IBOutlet weak var tfMobile: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    var company: CompanyDetails!
    override func viewDidLoad() {
        super.viewDidLoad()
        subview.layer.cornerRadius = 7
        getUser()
       company = getCompanyObject("SavedCompany")
        
        
        
        
    }
    @IBAction func updateDidPressed(_ sender: Any) {
         self.startActivityIndicator()
        
        let path = URL(string: Path.customerUrl + "/update")
        let firstName = tfFirstName.text
        let lastName = tfLastName.text
        let email = tfEmail.text
        let phone = tfPhone.text
        let mobile = tfMobile.text
    
        
        let parameters =   ["id":userData!.id,
                            "customerType": "\(userData!.customerType)",
                            "ipAddress": "\(userData!.ipAddress)",
                            "internalInfo": "",
                            "salutation": "",
                            "phone": "\(phone!)",
                            "mobile": "\(mobile!)",
                            "firstName": "\(firstName!)",
                            "lastName": "\(lastName!)",
                            "email": "\(email!)",
                            "salt": "",
                            "promotionSMS": false,
                            "promotionEmail":  false,
                            "registrationDate": "\(userData!.registrationDate)",
                            "status": userData!.status,
                            "password": userData!.password,
                            "branchId": userData?.branchID,
                            "addresses": [],
                            "companyId": userData!.companyID
                        ] as [String:Any]
        
        var request = URLRequest(url: path!)
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
            
            
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])as? NSDictionary
                    let jsonData = try JSONSerialization.data(withJSONObject: json as Any, options: .prettyPrinted)
                    let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    let jsonData1 = encodedObjectJsonString.data(using: .utf8)
                    if let httpResponse = response as? HTTPURLResponse {
                        print("error \(httpResponse.statusCode)")
                        if httpResponse.statusCode == 200{
                            restResponse = true
                            self.stopActivityIndicator()
                            self.tfFirstName.text = ""
                            self.tfLastName.text = ""
                            self.tfEmail.text = ""
                            self.tfPhone.text = ""
                            self.tfMobile.text = ""
                            //self.showAlert(title: "Request Completed", message: "")
                        }
                        else
                        {
                            self.showAlert(title: "Request Decline", message: "Something goes worng")
                        }
                    }
                    
                } catch {
                    print(error)
                }
            }
            
            }.resume()
        
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
                            self.tfFirstName.text  = self.userData?.firstName
                            self.tfLastName.text =  self.userData?.lastName
                            self.tfEmail.text =  self.userData?.email
                            self.tfMobile.text = self.userData?.mobile
                            self.tfPhone.text = self.userData?.phone
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
//"id":company.id,
//"name": "\(company.name)",
//"description": "\(company.description)",
//"locationWebLogoURL": "\(company.locationWebLogoURL)",
//"iOSAppURL": "\(company.iOSAppURL)",
//"androidAppURL": "\(company.androidAppURL)",
//"status": company.status,
//"archive": company.archive,
//"salesCompanyName": "\(company.salesCompanyName)",
//"clientSendPushNotification": company.clientSendPushNotification,
//"homeURL": "\(company.homeURL)",
//"companyEmailDetails": "\(company.companyEmailDetails)",
//"country": "\(company.country)",
//"companyType": company.companyType,
//"deliveryZoneType": company.deliveryZoneType,
//"companyTemplate": company.companyTemplate,
//"listingRedirection": company.listingRedirection,
//"companyLocales": company.companyLocales,
//"addressFieldRules": company?.addressFieldRules

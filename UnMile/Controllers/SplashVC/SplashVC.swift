//
//  SplashVC.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/5/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import AlamofireImage

class SplashVC: BaseViewController {

    @IBOutlet weak var verticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserDetail()
        getCompanyDetails()
    }

    // MARK: - API Calls
    func getCompanyDetails() {

        let path = Path.companyUrl + "/\(companyId)"

        NetworkManager.getDetails(path: path, params: nil, success: { (json, isError) in

            do {
                let jsonData =  try json.rawData()
                let companyDetails = try JSONDecoder().decode(CompanyDetails.self, from: jsonData)
                
                print(companyDetails)
                self.saveCompanyObject(Object: companyDetails, key: "SavedCompany")
                UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                    //self.verticalCenterConstraint.constant = (UIScreen.main.bounds.height/2 - 100) - (180+216)
                    self.view.layoutIfNeeded()
                    self.activityIndicatorView.isHidden = true
                }, completion: nil)

                if let tabbarVC = Storyboard.main.instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController,
                    let nvc = tabbarVC.viewControllers?[0] as? UINavigationController,
                    let mainVC = nvc.viewControllers[0] as? MainVC {
                    mainVC.companyDetails = companyDetails
                    mainVC.deliveryZoneType = companyDetails.deliveryZoneType.name //"POSTALCODE"

                    UIApplication.shared.keyWindow!.replaceRootViewControllerWith(tabbarVC, animated: true, completion: nil)
                }

            } catch let myJSONError {
                print(myJSONError)
                self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
            }

        }) { (error) in
            //self.dismissHUD()
            self.showAlert(title: Strings.error, message: error.localizedDescription)
        }
    }
    
    
  
    }
    

struct CompanyDetails: Codable {
    let id: Int
    let name, description: String
    let locationWebLogoURL: String
    let iOSAppURL: String
    let androidAppURL: String
    let status, archive, clientSendPushNotification: Int
    let salesCompanyName, salesCompanyWebsite: String
    let homeURL: String?
    let companyEmailDetails: CompanyEmailDetails
    let country: Country
    let companyType, deliveryZoneType: CompanyTypeClass
    let companyTemplate: CompanyTemplate
    let listingRedirection: String
    let companyLocales: [CompanyLocale]
    let addressFieldRules: [AddressFieldRule]

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case locationWebLogoURL = "locationWebLogoUrl"
        case iOSAppURL, androidAppURL, status, archive, clientSendPushNotification, salesCompanyName, salesCompanyWebsite, homeURL, companyEmailDetails, country, companyType, deliveryZoneType, companyTemplate, listingRedirection, companyLocales, addressFieldRules
    }
}

struct AddressFieldRule: Codable {
    let id: Int
    let fieldName, label: String
    let display, addressFieldRuleRequired, minLength, maxLength: Int
    let userInterfaceClass, userInterfaceType: String
    let position, parent, status, archive: Int

    enum CodingKeys: String, CodingKey {
        case id, fieldName, label, display
        case addressFieldRuleRequired = "required"
        case minLength, maxLength, userInterfaceClass, userInterfaceType, position, parent, status, archive
    }
}

struct CompanyEmailDetails: Codable {
    let id, defaultDetails: Int
    let emailHost, emailPort, donotReplyEmail, donotReplyUserName: String
    let donotReplyPassword, customerCareEmail, infoEmail, supportEmail: String
    let adminEmail, phone: String
    let facebookURL, instagramURL: String
    let twitterURL, adminCellNumber, customercarecellnumber: String

    enum CodingKeys: String, CodingKey {
        case id, defaultDetails, emailHost, emailPort, donotReplyEmail, donotReplyUserName, donotReplyPassword, customerCareEmail, infoEmail, supportEmail, adminEmail, phone
        case facebookURL = "facebookUrl"
        case instagramURL = "instagramUrl"
        case twitterURL = "twitterUrl"
        case adminCellNumber, customercarecellnumber
    }
}

struct CompanyLocale: Codable {
    let id: Int
    let country, language: String
    let isdefault, status, archive: Int
}

struct CompanyTemplate: Codable {
    let id: Int
    let name, standardFolderPath, rootStaticURL: String
    let status, archive: Int

    enum CodingKeys: String, CodingKey {
        case id, name, standardFolderPath
        case rootStaticURL = "rootStaticUrl"
        case status, archive
    }
}

struct CompanyTypeClass: Codable {
    let id: Int
    let name: String
    let createdate: String?
    let status, archive: Int
}

struct Country: Codable {
    let id: Int
    let country: String
    let status, archive: Int
}

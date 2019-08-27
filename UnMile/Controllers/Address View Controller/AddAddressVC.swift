//
//  AddAddressVC.swift
//  UnMile
//
//  Created by iMac on 08/05/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import Alamofire

class AddAddressVC: BaseViewController {

    @IBOutlet var addressView2: UIView!
    @IBOutlet var addressView1: UIView!
    @IBOutlet var txtAddress1: UITextField!
    @IBOutlet var txtAddress2: UITextField!
    @IBOutlet var btnArea: UIButton!
    @IBOutlet var btnCity: UIButton!
    var companyDetails: CompanyDetails!
    var cityAreaView: CityAreaView!
    var customerAddress : Address?
    var addressFeilds = [AddressField]()
    var addressFeild: AddressField!
    var city: CityObject?
    var area: AreaObject?
    var edit = false
    var addressId:Int?
    var fieldId:[Int]!
    var editAddress : Address?
    var coustomerId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavigationBar()
        addressView2.layer.cornerRadius = 7
        addressView1.layer.cornerRadius = 7
        btnArea.layer.cornerRadius = 7
        btnCity.layer.cornerRadius = 7
        
        customerCheck = getCustomerObject("savedCustomer")
        if customerCheck != nil  {
           coustomerId = customerCheck.id
        }
        if(edit == true ){
        
           txtAddress1.text = editAddress?.addressFields[0].fieldValue
            
            
        }
        self.navigationController?.isNavigationBarHidden = false
        //self.showNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /// Getting Saved City and Area Values
        
        if let savedCity = UserDefaults.standard.object(forKey: "cityAddress") as? Data  {
            let decoder = JSONDecoder()
            if let loadedCity = try? decoder.decode(CityObject.self, from: savedCity) {
               city = loadedCity
               btnCity.setTitle(loadedCity.name, for: .normal)
            }
           //self.showNavigationBar()
        }
        
        
        if let savedArea = UserDefaults.standard.object(forKey: "cityAreaAddress") as? Data  {
            let decoder = JSONDecoder()
            if let loadedArea = try? decoder.decode(AreaObject.self, from: savedArea) {
                area = loadedArea
                btnArea.setTitle(loadedArea.area, for: .normal)
            }
        }
        
    }
    
    @IBAction func addCityTapped(_ sender: Any) {
        CityArea(sender: sender as! UIButton)
    }
    @IBAction func addAreaTapped(_ sender: Any) {
          CityArea(sender: sender as! UIButton)
    }
    @IBAction func addAddressTapped(_ sender: Any) {
        
        if (txtAddress1.text == "" || txtAddress2.text == ""){
            showAlert(title: "Address Fields are Empty", message: "Must Enter One Address Feilds")
        }
        else
        {
           if (edit == true)
           {
            updateAddressToServer()
            
            }
           else {
              addAddressToServer()
            }
          
            self.txtAddress1.text = ""
            self.txtAddress2.text = ""
           
        }
    }
    
    func addAddressToServer(){
        
        let path = URL(string: Path.addressUrl + "/add-address")
        let parameters = ["id":0,
                          "isDefault":0,
                          "archive":0,
                          "addressFields":[["fieldName":"addressLine1","fieldValue":"\(txtAddress1!.text!)","label":"addressLine1"],["fieldName":"addressLine2","fieldValue":"\(txtAddress2!.text!)","label":"addressLine2"],["fieldName":"city","fieldValue":"\(city!.name)","label":"city"],["fieldName":"area","fieldValue":"\(area!.area)","label":"area"]],
                           "customer": ["id":customerCheck.id, "customerType": "\(customerCheck.customerType)", "ipAddress": "\(customerCheck.ipAddress)", "internalInfo": "\(customerCheck.internalInfo)", "salutation": "\(customerCheck.salutation)", "phone": "\(customerCheck.phone)", "mobile": "\(customerCheck.mobile)", "firstName": "\(customerCheck.firstName)", "lastName": "\(customerCheck.lastName)", "email": "\(customerCheck.email)", "salt": "\(customerCheck.salt)", "promotionSMS": "\(customerCheck.promotionSMS)", "promotionEmail": "\(customerCheck.promotionEmail)", "registrationDate": customerCheck.registrationDate, "companyID": customerCheck.companyID, "branchID": customerCheck.branchID, "status": customerCheck.status, "addresses": []]
            ] as [String: Any]
        
        NetworkManager.postDetails(path: path! , parameters: parameters)
        
    }
    func updateAddressToServer(){
        
        let path = URL(string: Path.addressUrl + "/update-address")
        let parameters = ["id": addressId!,
                          "isDefault":0,
                          "archive":0,
                          "addressFields":[["id": fieldId[0],"fieldName":"addressLine1","fieldValue":"\(txtAddress1!.text!)","label":"addressLine1"],["id": fieldId[1],"fieldName":"addressLine2","fieldValue":"\(txtAddress2!.text!)","label":"addressLine2"],["id": fieldId[2],"fieldName":"city","fieldValue":"\(city!.name)","label":"city"],["id": fieldId[3],"fieldName":"area","fieldValue":"\(area!.area)","label":"area"]],
                          "customer": ["id":customerCheck.id, "customerType": "\(customerCheck.customerType)", "ipAddress": "\(customerCheck.ipAddress)", "internalInfo": "\(customerCheck.internalInfo)", "salutation": "\(customerCheck.salutation)", "phone": "\(customerCheck.phone)", "mobile": "\(customerCheck.mobile)", "firstName": "\(customerCheck.firstName)", "lastName": "\(customerCheck.lastName)", "email": "\(customerCheck.email)", "salt": "\(customerCheck.salt)", "promotionSMS": "\(customerCheck.promotionSMS)", "promotionEmail": "\(customerCheck.promotionEmail)", "registrationDate": customerCheck.registrationDate, "companyID": customerCheck.companyID, "branchID": customerCheck.branchID, "status": customerCheck.status, "addresses": []]
            ] as [String: Any]
        
        NetworkManager.postDetails(path: path! , parameters: parameters)
        
    }
   
    
    func CityArea(sender: UIButton) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : SearchVC = storyboard.instantiateViewController(withIdentifier: SearchVC.identifier) as! SearchVC
        //self.present(vc, animated: true, completion: nil)
        
//        guard let searchVC = Storyboard.main.instantiateViewController(withIdentifier: SearchVC.identifier) as? SearchVC else {
//            fatalError("\(SearchVC.identifier) not found")
//        }
        
        vc.isFor = SearchFor(rawValue: sender.tag)!
        if sender.tag == 0 {
            //searchVC.cityDelegate = self as! SearchVCCityDelegate
            vc.companyId = 52
            vc.addressSelection = true
            UserDefaults.standard.removeObject(forKey: "SavedArea")
            btnArea.setTitle("Area", for: .normal)
            self.present(vc, animated: true, completion: nil)
            //self.navigationController?.pushViewController(vc, animated: true)
            
            
        } else {
            
            if let savedCity = UserDefaults.standard.object(forKey: "cityAddress") as? Data  {
                let decoder = JSONDecoder()
                if let loadedCity = try? decoder.decode(CityObject.self, from: savedCity) {
                    
                  //  searchVC.areaDelegate = self as! SearchVCAreaDelegate
                    vc.cityId = loadedCity.id
                    vc.companyId = 52
                     vc.addressSelection = true
                    self.present(vc, animated: true, completion: nil)
                   // self.navigationController?.pushViewController(vc, animated: true)
                }
            }
                
                
            else{
                
                if let aCity = self.city {
                    vc.areaDelegate = self as! SearchVCAreaDelegate
                    vc.cityId = aCity.id
                    vc.companyId = self.companyDetails.id
                    self.present(vc, animated: true, completion: nil)
                   // self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showAlert(title: "Select city!", message: "Please select city to continue")
                }
            }
        }
    }
}

//
//  BaseControllers.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/5/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
//import SVProgressHUD

class BaseViewController: UIViewController {

    var cityCheck: CityObject?
    var areaCheck: AreaObject?
    var branchCheck: BranchWrapperAppList?
    var customerCheck: CustomerDetail!
    var companyCheck: CompanyDetails!
    var currentAddress : Address!
    var address: AddressField?
    var totalPrice = 0.0
    var saveCustomerAddress : [Address]!
    private var customerAddressDetails : [Address]!
    let activityIndicatorView:UIActivityIndicatorView = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back")
//
//        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back")
//
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }

//    func dismissHUD() {
//        DispatchQueue.main.async {
//            SVProgressHUD.dismiss()
//        }
//    }
//
//    func showHUD() {
//        SVProgressHUD.show()
//    }

    func showToast(controller: UIViewController , message: String , seconds: Double){
        
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor.black
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 16
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + seconds){
            alert.dismiss(animated: true)
        }
    }
    func showError() {
        showAlert(title: Strings.error, message: Strings.somethingWentWrong)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okButton)

        present(alert, animated: true, completion: nil)
    }
    
    func startActivityIndicator(){
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        
    }
    
    func stopActivityIndicator(){
        
        activityIndicatorView.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    
    func deleteFromCartAlert(title: String , message: String){
        
        let deleteAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            let alreadyItems = NSMutableArray.init(array: self.getAlreadyCartItems())
            if (alreadyItems.count != 0){
            alreadyItems.removeAllObjects()
            self.saveItems(allItems: alreadyItems as! [CustomerOrderItem])
            UserDefaults.standard.removeObject(forKey: "SavedBranch")
            UserDefaults.standard.removeObject(forKey:"branchAddress")
                self.dismiss(animated: true, completion: nil)
            
            }
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func logOutAlert(title: String , message: String, dataTable: UITableView ){
        
            
            let deleteAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            
            deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
               
                    UserDefaults.standard.removeObject(forKey: "savedCustomer")//(forKey: "savedCustomer")
                    UserDefaults.standard.removeObject(forKey: "customerName")
                    dataTable.reloadData()
            }))
            
            deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            present(deleteAlert, animated: true, completion: nil)
        
    }
    
    func orderPlaceAlert(title: String , message: String){
        
        
        let orderAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        orderAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : UIViewController = storyboard.instantiateViewController(withIdentifier: "CompleteSummeryVC") as! CompleteSummeryVC
                self.present(vc, animated: true, completion: nil)
        }))
        
        present(orderAlert, animated: true, completion: nil)
        
    }
    
    
    
    func hideNavigationBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }

    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func getAlreadyCartItems() -> [CustomerOrderItem]  {
        
        let docsURL = FileManager.documentsURL
        let docsFileURL = docsURL.appendingPathComponent("cart.json")
        
        let data = try! Data(contentsOf: docsFileURL, options: [])
        if JSONSerialization.isValidJSONObject(data) {
            print("Valid Json")
        } else {
            print("InValid Json")
        }
        let jsonResult = try? JSONSerialization.jsonObject(with: data, options: [])
        let jsonArray = jsonResult as! [NSDictionary]
        var prodsArray = NSMutableArray.init() as! [CustomerOrderItem]
        
        for anItem in jsonArray{
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: anItem, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                let jsonData1 = encodedObjectJsonString.data(using: .utf8)
                
                let itemBac = try? JSONDecoder().decode(CustomerOrderItem.self, from: jsonData1!)
                
                //totalPrice += (itemBac?.totalPrice) ?? (itemBac?.price)!
                
                
                prodsArray.append(itemBac!)
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return prodsArray
    }
    func getAlreadyAddress() -> [Address]  {

        let docsURL = FileManager.documentsURL
        let docsFileURL = docsURL.appendingPathComponent("Address.json")

        let data = try! Data(contentsOf: docsFileURL, options: [])
        if JSONSerialization.isValidJSONObject(data) {
            print("Valid Json")
        } else {
            print("InValid Json")
        }
        let jsonResult = try? JSONSerialization.jsonObject(with: data, options: [])
        let jsonArray = jsonResult as! [NSDictionary]
        var addressArray = NSMutableArray.init() as! [Address]

        for anItem in jsonArray{

            do {
                let jsonData = try JSONSerialization.data(withJSONObject: anItem, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                let jsonData1 = encodedObjectJsonString.data(using: .utf8)

                let itemBac = try? JSONDecoder().decode(Address.self, from: jsonData1!)

                //totalPrice += (itemBac?.totalPrice) ?? (itemBac?.price)!


                addressArray.append(itemBac!)


            } catch {
                print(error.localizedDescription)
            }
        }

        return addressArray
    }
    
    
    func getUserDetail() -> ([Address]?,CustomerDetail?){
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
                        self.customerCheck = try JSONDecoder().decode(CustomerDetail.self, from: jsonData1!)
                        self.saveCustomerObj(obj: self.customerCheck, key: "SavedCustomer")
                        print(self.customerCheck)
                        self.customerAddressDetails = self.customerCheck.addresses
                        self.saveCustomerAddress(obj: self.customerAddressDetails, key: "SavedAddress")
                        
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
    return (customerAddressDetails,customerCheck)
    }
//    func getUserDetail() -> ([Address]?,CustomerDetail?){
//
//        if let  Id = UserDefaults.standard.object(forKey: "customerId") as? Int{
//            customerId = Id
//            let path = Path.customerUrl + "/\(customerId)"
//
//            NetworkManager.getDetails(path: path, params: nil, success: { (json, isError) in
//
//                do {
//                    let jsonData =  try json.rawData()
//                    self.customerCheck = try JSONDecoder().decode(CustomerDetail.self, from: jsonData)
//                    self.saveCustomerObj(obj: self.customerCheck, key: "SavedCustomer")
//                    print(self.customerCheck)
//                    self.customerAddressDetails = self.customerCheck.addresses
//                    self.saveCustomerAddress(obj: self.customerAddressDetails, key: "SavedAddress")
//                } catch let myJSONError {
//                    print(myJSONError)
//                    self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
//                }
//
//            }) { (error) in
//                //self.dismissHUD()
//                self.showAlert(title: Strings.error, message: error.localizedDescription)
//            }
//        }
//        else{
//
//            print ("user is not logedin")
//        }
//
//        return (customerAddressDetails,customerCheck)
//    }
    func saveItems(allItems : [CustomerOrderItem])  {

        let docsURL = FileManager.documentsURL
        let docsFileURL = docsURL.appendingPathComponent("cart.json")

        let encodedObject = try? JSONEncoder().encode(allItems)
        let encodedObjectJsonString = String(data: encodedObject!, encoding: .utf8)
        let jsonData = encodedObjectJsonString!.data(using: .utf8)


        do {
            try FileManager.default.removeItem(at: docsFileURL)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }

        let bundlePath = Bundle.main.url(forResource: "cart", withExtension: "json")
        FileManager.default.copyItemFromURL(urlPath: bundlePath!, toURL: docsFileURL)




        if let file = FileHandle(forWritingAtPath:docsFileURL.path) {
            file.write(jsonData!)
            print("wrote")
        }

        let test = getAlreadyCartItems()
        print(String.init(format: "count after adding item is %i", test.count))


        //  let itemBac = try? JSONDecoder().decode(Product.self, from: jsonData)


    }
    func saveAddress(allAddress : [Address])  {

        let docsURL = FileManager.documentsURL
        let docsFileURL = docsURL.appendingPathComponent("Address.json")

        let encodedObject = try? JSONEncoder().encode(allAddress)
        let encodedObjectJsonString = String(data: encodedObject!, encoding: .utf8)
        let jsonData = encodedObjectJsonString!.data(using: .utf8)


        do {
            try FileManager.default.removeItem(at: docsFileURL)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }

        let bundlePath = Bundle.main.url(forResource: "Address", withExtension: "json")
        FileManager.default.copyItemFromURL(urlPath: bundlePath!, toURL: docsFileURL)




        if let file = FileHandle(forWritingAtPath:docsFileURL.path) {
            file.write(jsonData!)
            print("wrote")
        }

        let test = getAlreadyAddress()
        print(String.init(format: "count after adding item is %i", test.count))


        //  let itemBac = try? JSONDecoder().decode(Product.self, from: jsonData)


    }
    
    func getTotalPriceFromCart() -> Double  {
        
        let docsURL = FileManager.documentsURL
        let docsFileURL = docsURL.appendingPathComponent("cart.json")
        
        let data = try! Data(contentsOf: docsFileURL, options: [])
        if JSONSerialization.isValidJSONObject(data) {
            print("Valid Json")
        } else {
            print("InValid Json")
        }
        let jsonResult = try? JSONSerialization.jsonObject(with: data, options: [])
        let jsonArray = jsonResult as! [NSDictionary]
        for anItem in jsonArray{
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: anItem, options: .prettyPrinted)
                // here "jsonData" is the dictionary encoded in JSON data
                let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                let jsonData1 = encodedObjectJsonString.data(using: .utf8)
                
                let itemBac = try? JSONDecoder().decode(CustomerOrderItem.self, from: jsonData1!)
                
                totalPrice += (Double((itemBac?.purchaseSubTotal)!) * (Double((itemBac?.quantity)!)))
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return totalPrice
    }
    
    func setDict(dict: NSDictionary) {
        let data = NSKeyedArchiver.archivedData(withRootObject: dict)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey:"keyHere")
    }
    
    
        func getDict() -> NSDictionary {
        let data = UserDefaults.standard.object(forKey: "keyHere") as! NSData
        let object = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! NSDictionary
        return object;
    }
    
    func saveCustomerObj(obj: CustomerDetail, key: String) {
       
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(obj) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    func saveCustomerAddress(obj: [Address], key: String) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(obj) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    func saveCustomerOrder(obj: CustomerOrder, key: String) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(obj) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    func saveBranchWrapper(Object: [BranchWrapperAppList], key: String) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
        
    }
    
    func saveCityObject(Object : CityObject , key: String){
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    func saveAreaObject(Object : AreaObject , key: String){
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    func getSavedCityObject(key: String) -> CityObject {
       
        if let savedCity = UserDefaults.standard.object(forKey: key) as? Data  {
            let decoder = JSONDecoder()
            if let loadedCity = try? decoder.decode(CityObject.self, from: savedCity) {
                cityCheck = loadedCity
            }
            
        }
        return cityCheck!
    }
    func getSavedCustomerAddress(key: String) -> [Address]? {
        
        if let savedCity = UserDefaults.standard.object(forKey: key) as? Data  {
            let decoder = JSONDecoder()
            if let loadedCity = try? decoder.decode([Address].self, from: savedCity) {
                self.saveCustomerAddress = loadedCity
            }
            return self.saveCustomerAddress
        }
        else { return nil }
    }
    
    func getSavedAreaObject(key: String) -> AreaObject? {
        
        if let savedArea = UserDefaults.standard.object(forKey: key) as? Data  {
            let decoder = JSONDecoder()
            if let loadedArea = try? decoder.decode(AreaObject.self, from: savedArea) {
                areaCheck = loadedArea
            }
             return areaCheck!
        }
        else{
            return nil
        }
       
    }
    
    func saveCompanyObject(Object : CompanyDetails , key: String){
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    func saveBranchObject(Object : BranchWrapperAppList , key: String){
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
   
    func saveBranchAddress(Object : Branch , key: String){
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    
    func saveSelectedProduct(Object : Product , key: String){
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(Object) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    func saveSelectedAddress(obj: Address, key: String) {
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(obj) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        }
    }
    func getBranchObject(key: String)-> BranchWrapperAppList
    {
        
        if let savedBranch = UserDefaults.standard.object(forKey: key) as? Data  {
            let decoder = JSONDecoder()
            if let loadedBranch = try? decoder.decode(BranchWrapperAppList.self, from: savedBranch) {
                branchCheck = loadedBranch
            }
    }
        return branchCheck!
    }
    
     func getCustomerObject(_ key:String)-> CustomerDetail?
    {
        
        if let savedCustomer = UserDefaults.standard.object(forKey: key) as? Data  {
            let decoder = JSONDecoder()
            if let loadedCustomer = try? decoder.decode(CustomerDetail.self, from: savedCustomer) {
                customerCheck = loadedCustomer
            }
        }
        return customerCheck
    }
    func getCompanyObject(_ key:String)-> CompanyDetails
    {
        
        if let savedCustomer = UserDefaults.standard.object(forKey: key) as? Data  {
            let decoder = JSONDecoder()
            if let loadedCompany = try? decoder.decode(CompanyDetails.self, from: savedCustomer) {
                companyCheck = loadedCompany
            }
        }
        return companyCheck
    }
}


//
//  AddressVC.swift
//  UnMile
//
//  Created by iMac on 08/05/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class AddressVC: BaseViewController {

    var totalAddress : [Address]!
    var addressList : [Address]!

    
    var addressFields = [AddressField]()
    var addressField : CustomerOrderAddressField!
    var customerorderaddress : CustomerOrderAddress!
    var edit = false
    var addressId = 0
    var fieldId:[Int] = []
    
    @IBOutlet var tblAddress: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.]
        fieldId.reserveCapacity(4)
        
        totalAddress  = getSavedCustomerAddress(key: "customerAddress")
            
        addressList = totalAddress.filter { $0.archive == 0 }
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //`totalAddress = getAlreadyAddress()
         self.getUserDetail()
        addressList = totalAddress.filter { $0.archive == 0 }
        tblAddress.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "address2addAddress"){
            if(edit == true)
            {
                let vc = segue.destination as? AddAddressVC
                vc?.edit = true
                vc?.editAddress = self.currentAddress
                vc?.addressId = self.addressId
                vc?.fieldId = self.fieldId
            }
            
        }
        else{
            let vc = segue.destination as? CheckOutVC
        }
        
    }
    func deleteAddress(addressId: Int){
        
        let path = Path.addressUrl + "/delete/" + "\(addressId)"
        NetworkManager.getDetails(path: path, params: nil, success: { (json, isError) in
            do{
               print("response")
                
            }catch let myJSONError {
                print(myJSONError)
                self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
            }
            
        }) { (error) in
            //self.dismissHUD()
            self.showAlert(title: Strings.error, message: error.localizedDescription)
        }
    }

    @IBAction func addNewAddress(_ sender: Any) {
        //performSegue(withIdentifier: "address2addAddress", sender: self)
//         let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
//        self.present(controller, animated: true, completion: nil)
       // let initialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        let userAddress = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAddressVC")
        //let navi =  UINavigationController.init(rootViewController: initialVC)
        self.navigationController?.pushViewController(userAddress, animated: true)
    }
    
}
extension AddressVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AddressTableViewCell
            cell.delegate = self
        var customerAddress = ""
        var cityArea = ""
        
        for i in 0...3
            {
                if(addressList[indexPath.row].addressFields[i].label == "addressLine1" || addressList[indexPath.row].addressFields[i].label == "addressLine2"){
                     customerAddress += addressList[indexPath.row].addressFields[i].fieldValue
                }
               else if(addressList[indexPath.row].addressFields[i].label == "city" || addressList[indexPath.row].addressFields[i].label == "area"){
                    cityArea += addressList[indexPath.row].addressFields[i].fieldValue
                    
                }
           
        }
            cell.lblFullAddress.text = customerAddress
            cell.lblCityArea.text = cityArea
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        currentAddress = addressList![indexPath.row]
        saveSelectedAddress(obj: currentAddress, key: "selectedAddress")
       
    
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let alreadyAddress = addressList
            if (alreadyAddress?.count != 0){
                deleteAddress(addressId: addressList[indexPath.row].id)
                totalAddress.remove(at: indexPath.row)
                self.tblAddress.deleteRows(at: [indexPath] , with: .fade)
                tblAddress.reloadData()
                }
            }
        }
    }

extension AddressVC : editAddressDelegate{
    func didTappedEdit(cell: AddressTableViewCell) {
    let indexPath = self.tblAddress.indexPath(for: cell)
        currentAddress = addressList[(indexPath?.row)!]
        edit = true
        fieldId.removeAll()
        for field in 0...3{
            fieldId.append(addressList[(indexPath?.row)!].addressFields[field].id)
        }
        addressId = addressList[(indexPath?.row)!].id
        //performSegue(withIdentifier: "address2addAddress", sender: self)
        let userAddress = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddAddressVC") as! AddAddressVC
        //let navi =  UINavigationController.init(rootViewController: initialVC)
        userAddress.edit = true
        userAddress.editAddress = self.currentAddress
        userAddress.addressId = self.addressId
        userAddress.fieldId = self.fieldId
        self.navigationController?.pushViewController(userAddress, animated: true)
    }
    }




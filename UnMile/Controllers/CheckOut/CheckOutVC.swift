//
//  CheckOutVC.swift
//  UnMile
//
//  Created by iMac on 20/03/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class CheckOutVC: BaseViewController {
 
    @IBOutlet var checkOutButton: UIButton!
    @IBOutlet var tblCheckOut: UITableView!
    var userName = ""
    var userEmail = ""
    var userPhone = ""
    var userLogo: [UIImage] = [UIImage(named: "user")! , UIImage(named: "mail")! , UIImage(named: "phone-1")!]
    var paymentLogo: [UIImage] = [UIImage(named: "cash-1")! , UIImage(named: "credit-card")!]
    var branch : BranchWrapperAppList!
    var sectionTitle = [ "User","Promo Code","Order Type","Delivery Address","Payment Type","Special Instruction(optional)"]
    var oderType = ""
    var paymentType = ""
    var specialInstruction = ""
    var selectedAddress: CustomerOrderAddress!
    var userArray = [String]()
    var userKeyArray = [String]()
    var orderSelectedIndex:NSIndexPath?
    var paymentSelectedIndex : NSIndexPath?
    var firstOrderTypeIndex = 0
    var firstPaymentTypeIndex = 0
    var totalprice = 0.0
    var orderDate = ""
    var orderTime = ""
    var customerOrderItem : [CustomerOrderItem]!
    var customerOrder: CustomerOrder!
    var custorder = [CustomerOrder]()
    var customerOrderAddresss : CustomerOrderAddress?
    var alreadyAddress : [CustomerOrderAddress]!
    var transId = ""
    var subTotal = 0.0
    var branchId = 0
    var radioControllerChoice : SSRadioButtonsController = SSRadioButtonsController()
    var radioControllerDip : SSRadioButtonsController = SSRadioButtonsController()
    var customer : CustomerDetail!
    var selectedArray : [IndexPath] = [IndexPath]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        orderDate = currentDateTime()
        orderTime = currentTime()
        transId  = getTransId()
        customerOrderItem = getAlreadyCartItems()
        subTotal = getTotalPriceFromCart()
        getUser()
       
        if let savedBranch = UserDefaults.standard.object(forKey: "branchAddress") as? Data  {
            let decoder = JSONDecoder()
            if let loadedBranchAddress = try? decoder.decode(Branch.self, from: savedBranch) {
             branchId = loadedBranchAddress.id
            }
        }
    
        
        checkOutButton.layer.cornerRadius = 7
        checkOutButton.layer.borderWidth = 2
        tblCheckOut.register(UINib(nibName: "OrderType", bundle: Bundle.main), forCellReuseIdentifier: "odercell")
        tblCheckOut.register(UINib(nibName: "DeliveryAddress", bundle: Bundle.main), forCellReuseIdentifier: "deliverycell")
        tblCheckOut.register(UINib(nibName: "SpecialInstruction", bundle: Bundle.main), forCellReuseIdentifier: "instructioncell")
        tblCheckOut.register(UINib(nibName: "PaymentMethodCell", bundle: Bundle.main), forCellReuseIdentifier: "paymentcell")
        tblCheckOut.register(UINib(nibName: "PromoCodeCell", bundle: Bundle.main), forCellReuseIdentifier: "promocell")
       
            if let savedBranch = UserDefaults.standard.object(forKey: "SavedBranch") as? Data  {
            let decoder = JSONDecoder()
            if let loadedCity = try? decoder.decode(BranchWrapperAppList.self, from: savedBranch) {
                branch = loadedCity
            }
            // Do any additional setup after loading the view.
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        tblCheckOut.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "checkout2Summary"
    {
        let vc = segue.destination as? PlaceOrderVC
        vc?.customerOrder = customerOrder
        }
    }
    
    @IBAction func goToSummary(_ sender: Any) {
        if (selectedAddress == nil )
        {
            showAlert(title: "Address is empty", message: "Select Delivery Address")
        }
        else if (paymentType == "" || oderType == ""){
            
            showAlert(title: "Selection Missing", message: "Must select all selection")
        }
        else{
        
            
            customerOrder = CustomerOrder.init(id: 0, customerType: customer.customerType, transID: transId, ipAddress: customer.ipAddress, orderDate: orderDate, specialInstructions: specialInstruction, customerPhone: customer.phone, customerFirstName: customer.firstName, customerLastName: customer.lastName, orderStatus: "PENDING", billingStatus: "false", printingStatus: "false", creditStatus: "false", orderType: oderType, paymentType: paymentType, orderTime: "ASAP (Around 75 Minutes)", promoCode: "false", sitePreference: "false", paymentGateway: "false", paymentGatewayReference: "false", orderConfirmationStatus: "PENDING", orderConfirmationStatusMessage: "AUTOCONFIRMED", deliveryCharge: 0, surCharge: 0.0, amount: subTotal, subTotal: subTotal, orderDiscount: 0.0, promoCodeDiscount: 0.0, orderCredit: "false", customerID: customer.id, branchID: branchId, processedBySoftware: 0, phoneNotify: false, sendFax: false, sendSMS: false, firstCustomerOrder: false, preOrdered: 0, companyID: companyId, customerOrderAddress: selectedAddress! , customerOrderTaxes: [], customerOrderItem: customerOrderItem, invoiceOrderDetailID: "false", cardOption: "false")
            
            
               performSegue(withIdentifier: "checkout2Summary", sender: self)
            
        }
        
    }
    func getTransId() -> String
    {
        
        let areaUrl = Path.transIdUrl + "/new"
        NetworkManager.getDetails(path: areaUrl , params: nil, success: { (json, isError) in
            
            do {
                self.transId = json.rawString()!
//                self.transId =  String(data:  jsonData, encoding: String.Encoding.utf8)!
               // let anArray = try JSONDecoder().decode(AreaResponse.self, from: jsonData)
                
            } catch let myJSONError {
                print(myJSONError)
                self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
            }
            
        }) { (error) in
           
            self.stopActivityIndicator()
            self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
        }
        
return transId
    }

    func currentDateTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    func currentTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
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
                        self.customer = try JSONDecoder().decode(CustomerDetail.self, from: jsonData1!)
                        DispatchQueue.main.async {
                            self.userName = self.customer.firstName
                            self.userEmail = self.customer.email
                            self.userPhone = self.customer.phone
                            self.userArray.append(self.userName)
                            self.userArray.append(self.userEmail)
                            self.userArray.append(self.userPhone)
                            self.tblCheckOut.reloadData()
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



extension CheckOutVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return userArray.count
        }
       
        else if (section == 2)
        {
            return branch.services.count
            
        }
       
        else if(section == 4)
        {
            
            
            return branch.paymentTypes.count
        }
        else {
            
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if(indexPath.section == 0)
        {
            
            guard let  cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CheckOutTableViewCell else {
                fatalError("Unknown cell")
            }
            
            
       
                cell.lblUser.text = "\(userArray[indexPath.row])"
                cell.icons.image = userLogo[indexPath.row]
            
            
            return cell
            
            
        }
         if(indexPath.section == 1)
        {
            guard let  cell = tableView.dequeueReusableCell(withIdentifier: "promocell", for: indexPath) as? PromoCodeCell else {
                fatalError("Unknown cell")
            }
            cell.verifyButton.layer.cornerRadius = 8
            cell.verifyButton.layer.borderWidth = 1
            cell.delegate = self as PromoCodeDelegate
            return cell
        }
        if (indexPath.section == 2){
            guard let orderCell = tableView.dequeueReusableCell(withIdentifier: "odercell", for: indexPath) as? OrderType
                else {
                    fatalError("Unknown cell")
            }
            
            orderCell.orderTypelbl.text = "\(branch.services[indexPath.row])"
            
            
            orderCell.selectionStyle = UITableViewCell.SelectionStyle.none;
            
            if (orderSelectedIndex == indexPath as NSIndexPath || firstOrderTypeIndex == 0) {
                orderCell.radioButton.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
                oderType = "\(branch.services[indexPath.row])"
                oderType = oderType.uppercased()
                firstOrderTypeIndex = 1
            } else {
                orderCell.radioButton.setImage(UIImage(named: "radio-button-uncheck"),for:UIControl.State.normal)

            }

            return orderCell
            
            
        }
         if (indexPath.section == 3){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "deliverycell", for: indexPath) as? DeliveryAddress
                else {
                    fatalError("Unknown cell")
            }
            if let savedBranch = UserDefaults.standard.object(forKey: "selectedAddress") as? Data  {
                let decoder = JSONDecoder()
                if let loaded = try? decoder.decode(Address.self, from: savedBranch) {
                    
                    selectedAddress  =  CustomerOrderAddress.init(id: 0, addressID: loaded.id, customerOrderAddressFields: loaded.addressFields)

                }
                // Do any additional setup after loading the view.
            }
            if(selectedAddress != nil){
                cell.deliveryAddress.text = "\(selectedAddress.customerOrderAddressFields[1].fieldValue + " " + selectedAddress.customerOrderAddressFields[2].fieldValue + " " + selectedAddress.customerOrderAddressFields[3].fieldValue)"
            }
            

           
            cell.delegate = self
            return cell
        }
         if(indexPath.section == 4)
        {
            
            guard let paymentCell = tableView.dequeueReusableCell(withIdentifier: "paymentcell", for: indexPath) as? PaymentMethodCell
                else {
                    fatalError("Unknown cell")
            }
            
            
            paymentCell.selectionStyle = UITableViewCell.SelectionStyle.none;
            paymentCell.logo.image = paymentLogo[indexPath.row]
            paymentCell.lblPaymentMethod.text = "\(branch.paymentTypes[indexPath.row])"
            paymentCell.delegate = self
            
            if (paymentSelectedIndex == indexPath as NSIndexPath || firstPaymentTypeIndex == 0) {
                paymentCell.radioButton.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
                oderType = "\(branch.services[indexPath.row])"
                oderType = oderType.uppercased()
                firstPaymentTypeIndex = 1
               
            } else {
                paymentCell.radioButton.setImage(UIImage(named: "radio-button-uncheck"),for:UIControl.State.normal)
            }

            return paymentCell
            
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "instructioncell", for: indexPath) as? SpecialInstruction
                else {
                    fatalError("Unknown cell")
            }
            
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return sectionTitle[section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        

        if (indexPath.section == 5) {
            
            return 88
        }
        else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.maximumMagnitude(50, 50)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 2 )
        {
            guard let cell = tableView.cellForRow(at: indexPath) as? OrderType
                else {
                    fatalError("Unknown cell")
            }
            cell.radioButton.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
            oderType = "\(branch.services[indexPath.row])"
            oderType = oderType.uppercased()
            print(oderType)
            orderSelectedIndex = indexPath as NSIndexPath
            tblCheckOut.reloadData()
            
        }
       else if(indexPath.section == 4 )
        {
            guard let cell = tableView.cellForRow(at: indexPath) as? PaymentMethodCell
                else {
                    fatalError("Unknown cell")
            }
            cell.radioButton.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
            
            paymentType = "\(branch.paymentTypes[indexPath.row])"
            paymentType = paymentType.uppercased()
            print(paymentType)
            paymentSelectedIndex = indexPath as NSIndexPath
            firstOrderTypeIndex = 0
            tableView.reloadData()
        
        }
    }
}
extension CheckOutVC: radioButtonDelelgate{
    func didCheckRadioButton(cell: PaymentMethodCell) {
        
       let indexPath = self.tblCheckOut.indexPath(for: cell)
        
        //let indexPath = self.tblCheckOut.indexPathForSelectedRow //optional, to get from any UIButton for example
        let currentCell = tblCheckOut.cellForRow(at: indexPath!) as! PaymentMethodCell
             currentCell.radioButton.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
             cell.radioButton.setImage(UIImage(named: "radio-button-uncheck"),for:UIControl.State.normal)
    }
    
    
    
}
extension CheckOutVC: PromoCodeDelegate {
    
    func didTappedVerificationButton()
    {
       
//        for discountRule in branch.discountRules {
//            if(branch.services[discountRule] = oderType
//                && branch.paymentTypes[discountRule] = paymentType
//                && totalprice > 0.0) {
//                showAlert(title: "Valid PromoCode", message: "Discount is avalaible to this promocode")
//
//            }
//            else{
//
//                showError()
//            }
//        }
        self.showAlert(title: "Tapped", message: "Verification button tapped")
    }
    
    
}
extension CheckOutVC: addAddressDelegate{
    func didTappedAddressButton(cell: DeliveryAddress) {
        let userAddress = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddressVC")
        userAddress.title = "User Address"
        self.navigationController?.pushViewController(userAddress, animated: true)
    }
    
    
    
}




//
//  PlaceOrderVC.swift
//  UnMile
//
//  Created by iMac on 20/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import Alamofire
class PlaceOrderVC: BaseViewController {

    @IBOutlet weak var tblOrderSummery: UITableView!
    var customerOrder: CustomerOrder!
    var customer: CustomerOrder!
    var OrderItem : [CustomerOrderItem]!
    var orderProduct : CustomerOrderItem!
    var instructions = ""
    var itemID = ""
    var finalsubTotal = 0.0
    var quantity = 0
    var selectedAddress : CustomerOrderAddress!
    var branch: Branch!
    var branchWrapper : BranchWrapperAppList!
    var surCharges = 0.0
    var sectionTitle = ["","Route","Order Summery","Detail","Contact Support"]
    var sectionOneArrayTitle = ["Total","Sur Charge","GST","Discount","Sub Total","Order Time"]
    var sectionOneArrayValue:[String]!
    var routeLogo: [UIImage] = [UIImage(named: "restaurant")! , UIImage(named: "location1")!]
    var routeArray:[String]!
    var restuarentAddress: String!
    var itemSummery : [CustomerOrderItem]!
    var paymentMethod : [PaymentMethod]!
    var customerOrderTax : [CustomerOrderTax]!
    var orderDiscount = 0.0
    var taxAmount = 0.0
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        itemSummery = getAlreadyCartItems()
        if let savedBranch = UserDefaults.standard.object(forKey: "branchAddress") as? Data  {
            let decoder = JSONDecoder()
            branch = try? decoder.decode(Branch.self, from: savedBranch)
            restuarentAddress  = branch.addressLine1
            paymentMethod = branch.paymentMethods
            
        }
        
        
        selectedAddress = customerOrder.customerOrderAddress
        customerOrderTax = calculateTaxes(restbranch: branch, customerOrder: customerOrder)
        surCharges = chargeSurcharge(customerOrder:customerOrder, paymentMethod: paymentMethod)
        orderDiscount = calculateDiscounts(branch: branch, customerOrder: customerOrder)
        finalsubTotal = getTotalPriceFromCart() + surCharges + taxAmount + orderDiscount
        sectionOneArrayValue = ["\(customerOrder.subTotal)","\(surCharges)","\(taxAmount)","\(orderDiscount)","\(finalsubTotal)","\(currentDateTime())"]
    
       
    
        routeArray = ["\(restuarentAddress ?? "")","\(selectedAddress!.customerOrderAddressFields[0].fieldValue + selectedAddress!.customerOrderAddressFields[1].fieldValue + selectedAddress!.customerOrderAddressFields[2].fieldValue + selectedAddress!.customerOrderAddressFields[3].fieldValue)"]
    
        tblOrderSummery.register(UINib(nibName: "Route", bundle: Bundle.main), forCellReuseIdentifier: "routecell")
        tblOrderSummery.register(UINib(nibName: "OrderItemsSummery", bundle: Bundle.main), forCellReuseIdentifier: "itemcell")
        tblOrderSummery.register(UINib(nibName: "OrderDetail", bundle: Bundle.main), forCellReuseIdentifier: "detailcell")
        tblOrderSummery.register(UINib(nibName: "ContactSupport", bundle: Bundle.main), forCellReuseIdentifier: "contactcell")

    }
    

    func currentDateTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
    @IBAction func tappedToPlaceOrder(_ sender: Any) {
       
        startActivityIndicator()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // customerOrder.customerOrderItem conversion into json data
        let jsonData = try! JSONEncoder().encode(customerOrder.customerOrderItem) //Data
        let jsonArray = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! Array<Dictionary<String, Any>>
        
        let adjustedCustomerOrderItemArray = NSMutableArray.init()
        
        for aDict in jsonArray{
            let newObj = NSMutableDictionary.init()
            
            newObj["customerOrderItemOptions"] = aDict["customerOrderItemOptions"]
            newObj["instructions"] = aDict["instructions"]
            newObj["orderItemId"] = aDict["orderItemId"]
            newObj["forWho"] = aDict["forWho"]
            newObj["product"] = aDict["product"]
            newObj["purchaseSubTotal"] = aDict["purchaseSubTotal"]
            newObj["quantity"] = aDict["quantity"]
            
            adjustedCustomerOrderItemArray.add(newObj)
            
        }
        print(adjustedCustomerOrderItemArray)
        let jsontaxData = try! JSONEncoder().encode(customerOrderTax) //Data
        let jsontaxArray = try! JSONSerialization.jsonObject(with: jsontaxData, options: []) as! Array<Dictionary<String, Any>>
        
        let adjustedJsontaxArray = NSMutableArray.init()
        
        for aDict in jsontaxArray{
            let newObj = NSMutableDictionary.init()
            newObj["orderType"] = aDict["orderType"]
            newObj["taxRule"] = aDict["taxRule"]
            newObj["taxLabel"] = aDict["taxLabel"]
            newObj["rate"] = aDict["rate"]
            newObj["taxAmount"] = aDict["taxAmount"]
            newObj["chargeMode"] = aDict["chargeMode"]

            adjustedJsontaxArray.add(newObj)
           
        }
         print(adjustedJsontaxArray)
        let postString = ["amount":customerOrder.amount,
                   "ipAddress": customerOrder.ipAddress,
                   "billingStatus":"\(customerOrder.billingStatus!)",
                   "branchId":"\(customerOrder.branchID)",
                   "creditStatus":"\(customerOrder.creditStatus)",
                   "customerFirstName":"\(customerOrder.customerFirstName)",
                   "customerId": "\(customerOrder.customerID)",
                   "customerLastName":"\(customerOrder.customerLastName)",
                   "customerOrderAddress":["customerOrderAddressFields":[["fieldName":"addressLine1","fieldValue":"\(selectedAddress.customerOrderAddressFields[0].fieldValue)","label":"\(selectedAddress.customerOrderAddressFields[0].label)"],["fieldName":"addressLine2","fieldValue":"\(selectedAddress.customerOrderAddressFields[1].fieldValue)","label":"\(selectedAddress.customerOrderAddressFields[1].label)"],["fieldName":"city","fieldValue":"\(selectedAddress.customerOrderAddressFields[2].fieldValue)","label":"\(selectedAddress.customerOrderAddressFields[2].label)"],["fieldName":"area","fieldValue":"\(selectedAddress.customerOrderAddressFields[3].fieldValue)","label":"\(selectedAddress.customerOrderAddressFields[3].label)"]]],
                   "customerOrderItem": adjustedCustomerOrderItemArray,
                   "customerOrderTaxes": adjustedJsontaxArray,
                   "customerPhone":"\(customerOrder.customerPhone)",
                   "customerType":"\(customerOrder.customerType)",
                   "deliveryCharge":"\(customerOrder.deliveryCharge)",
                   "firstCustomerOrder":true,
                   "orderConfirmationStatus":"AUTOCONFIRMED",
                   "orderConfirmationStatusMessage":"",
                   "orderDate": customerOrder.orderDate,
                   "orderDiscount": orderDiscount,
                   "orderStatus":"PROCESSED",
                   "orderTime":"ASAP (Around 75 Minutes)",
                   "orderType": customerOrder.orderType,
                   "paymentType": customerOrder.paymentType,
                   "phoneNotify":false,
                   "sendFax":false,
                   "sendSms":false,
                   "specialInstructions":"\(customerOrder.specialInstructions)",
                   "subTotal": "\(finalsubTotal)",
                   "transId":"\(customerOrder.transID)",
                   "surCharge": surCharges,
                   "companyId": customerOrder.companyID
                   ] as [String : Any]

        print(postString )
        guard let url = URL(string: Path.customerOrderUrl + "/create") else { return }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = postString as? [String : String]
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let jsoncheck =  try JSONSerialization.data(withJSONObject: postString , options: .prettyPrinted)
            
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
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: parseJSON, options: .prettyPrinted)
                    let encodedObjectJsonString = String(data: jsonData, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                    let jsonData1 = encodedObjectJsonString.data(using: .utf8)
                    let customerOrder = try JSONDecoder().decode(CustomerOrder.self, from: jsonData1!)
                    
        
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        UIApplication.shared.endIgnoringInteractionEvents()
                       self.orderPlaceAlert(title: "Order Placed", message: "Your Order is Places")
                        self.saveCustomerOrder(obj: customerOrder, key: "savedCustomerOrder" )
                       
                        
                        print(self.customerOrder.amount)
                    }
                    
                }
                else {
                    
                    //Display an Alert dialog with a friendly error message
             self.showAlert(title: "Request Error", message: "Could not successfully perform this request. Please try again later")
                    
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

    func  chargeSurcharge(customerOrder: CustomerOrder,  paymentMethod: [PaymentMethod])-> Double {
        
        for paymentmethod:PaymentMethod in paymentMethod{
            
            if(customerOrder.paymentType ==  paymentmethod.paymentType.name) {
        
                if(paymentmethod.chargeMode!.id == 1) {
                    surCharges = paymentmethod.charge!
                }
       
                else if (paymentmethod.chargeMode!.id == 2){
           
                    surCharges = customerOrder.subTotal * paymentmethod.charge!
                }
                finalsubTotal = finalsubTotal + surCharges
            }
        }
    
        return surCharges

    }
    
    func calculateTaxes(restbranch: Branch, customerOrder: CustomerOrder) -> [CustomerOrderTax]{

    if (!branch.taxes.isEmpty) {
        var taxRule = ""
        var taxLabel = ""
        var rate = 0.0
        var ChargeMode = 0
        var customerOrderTaxes = [CustomerOrderTax].self
       
        for  tax:Tax  in restbranch.taxes {
            if (tax.orderType.name == customerOrder.orderType) || (tax.orderType.name == "\(OrderType.self)") {
    
    if (tax.taxRule ==  tax.taxRule) {
    if (tax.chargeMode.id == 2 /** percentage */) {
    taxAmount = customerOrder.amount * tax.rate
    }
    } else if (tax.taxRule == tax.taxRule) {
    if (tax.chargeMode.id == 2 /** percentage */) {
    taxAmount = customerOrder.subTotal * tax.rate
    }
    } else if (tax.taxRule == tax.taxRule) {
    if (tax.chargeMode.id == 2 /** percentage */) {
    taxAmount = customerOrder.amount + customerOrder.deliveryCharge * tax.rate
    }
    } else if (tax.taxRule == tax.taxRule) {
    if (tax.chargeMode.id == 2 /** percentage */) {
        taxAmount = customerOrder.amount + customerOrder.surCharge! * tax.rate
    }
    }

    if (tax.chargeMode.id == 1 /** fixed */) {
    taxAmount = tax.rate
    }

//    customerOrderTax.orderType += customerOrder.orderType

     taxRule = tax.taxRule
     taxLabel = tax.taxLabel
     rate = tax.rate
     taxAmount += taxAmount
     ChargeMode = tax.chargeMode.id
    
       //customerOrderTaxes = customerOrderTaxes +  customerOrderTax
                
      finalsubTotal = customerOrder.subTotal + taxAmount
       }
    }
        customerOrderTax = [CustomerOrderTax.init(id: 1, orderType: customerOrder.orderType, taxRule: taxRule , taxLabel: taxLabel, rate: rate, taxAmount: taxAmount, chargeMode: ChargeMode)]
    
    } else {
   
        customerOrderTax = [CustomerOrderTax.init(id: 0, orderType: "", taxRule: "", taxLabel: "", rate: 0.0, taxAmount: 0, chargeMode: 0)]
    }

    return customerOrderTax
    }

    
    func calculateDiscounts(branch: Branch,  customerOrder: CustomerOrder)-> Double {

    var discount = [Double : Double]()
        for  orderDiscountRule: OrderDiscountRule  in branch.orderDiscountRules {
            
            var  expiryDate = orderDiscountRule.expiryDate
            var  today = "2019-01-01T00:00:00.000+0000"
            //customerOrder.orderType
    if(orderDiscountRule.status == 1 && orderDiscountRule.orderType.name == "DELIVERY" && orderDiscountRule.paymentType.name == customerOrder.paymentType && expiryDate > today)
    {
        var discountAmount = 0.0

        if(orderDiscountRule.chargeMode.id == 1)
        {
        discountAmount = orderDiscountRule.discount
        }
        else if(orderDiscountRule.chargeMode.id == 2)
        {
            discountAmount = customerOrder.subTotal - customerOrder.deliveryCharge * orderDiscountRule.discount
        }
        discount = [orderDiscountRule.subTotal : discountAmount]

    }
    else
    {
        discount = [0.0 : 0.0]
    //customerOrder.setOrderDiscount(BigDecimal.ZERO)
        }

        }

        if ((discount[0.0] != nil) )
        {
            discount.removeValue(forKey: 0.0)
        }

    if (discount.count > 0)
    {
    var lower = discount.values.min()
    var discount = discount[lower ?? 0.0]
        
        orderDiscount = discount ?? 0.0
        finalsubTotal = finalsubTotal - orderDiscount
    }
    else {
    orderDiscount = 0.0
    }

    return orderDiscount
    }

}

extension PlaceOrderVC: UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return sectionOneArrayTitle.count
            
        }
        else if(section == 1)
        {
            return routeArray.count
        }
        else if(section == 2)
        {
            return itemSummery.count
        }
        else{return 1}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ordercell", for: indexPath) as? OrderCompleteCell
                else {
                    fatalError("Unknown cell")
            }
            cell.lblAmount.text = sectionOneArrayTitle[indexPath.row]
            cell.lblAmountValue.text = sectionOneArrayValue[indexPath.row]
            return cell
        }
        else if(indexPath.section == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "routecell", for: indexPath) as? Route
                else {
                    fatalError("Unknown cell")
            }
            cell.imgRoute.image = routeLogo[indexPath.row]
            cell.lblRoute.text = routeArray[indexPath.row]
            return cell
        }
        else if (indexPath.section == 2){
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemcell", for: indexPath) as? OrderItemsSummery
                else {
                    fatalError("Unknown cell")
            }
            let items = itemSummery[indexPath.row]
            cell.lblSummeryItemName.text = items.product.name
            cell.lblSummeryItemPrice.text = "\(items.product.price)"
            cell.lblSummeryItemQuantity.text = "\(items.quantity ?? 0)"
            
            return cell
        }
        else if (indexPath.section == 3) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "detailcell", for: indexPath) as? OrderDetail
                else {
                    fatalError("Unknown cell")
            }
            
            cell.lblPaymentType.text =  "\(customerOrder.paymentType)"
            cell.lblInstruction.text = "\(customerOrder.specialInstructions)"
            cell.lblDeliveryTime.text = "minimum 50-70 mints"
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactcell", for: indexPath) as? ContactSupport
                else {
                    fatalError("Unknown cell")
            }
            cell.lblSupport.text = "For Any Qurrey or complain contact to our support Staff"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 2 && indexPath.row == 1 || indexPath.section == 3)
        {
            return 100
        }
        else {return 60}
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.frame = CGRect(x: 100, y: 5, width: 200, height: 50)
        headerView.backgroundColor =  UIColor.initWithHex(hex: "87cefa")
        let label = UILabel()
        label.frame = CGRect(x: tableView.bounds.size.width / 3  , y: 13, width: tableView.bounds.size.width - 10, height: 24)
        if section == 0{
            let imageView = UIImageView(frame: CGRect(x: 5, y: 8, width: 40, height: 40))
            if let savedBranch = UserDefaults.standard.object(forKey: "SavedBranch") as? Data  {
                let decoder = JSONDecoder()
                if let loadedBranch = try? decoder.decode(BranchWrapperAppList.self, from: savedBranch) {
                    if let urlString = loadedBranch.locationWebLogoURL,
                        
                        let url = URL(string: urlString) {
                        imageView.af_setImage(withURL: url, placeholderImage: UIImage(), imageTransition: .crossDissolve(1), runImageTransitionIfCached: false)
                        label.text = loadedBranch.name
                    }
                    
                    headerView.addSubview(imageView)
                    headerView.addSubview(label)
                }
            }
        }
        else{
            label.text = sectionTitle[section]
            headerView.addSubview(label)
        }
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0{
            
            let footerView = UIView()
            footerView.frame = CGRect(x: 100, y: 50, width: 200, height: 50)
            let label = UILabel()
            label.frame = CGRect(x: 5  , y: 0, width: tableView.bounds.size.width - 10, height: 24)
            label.text = "Delivery Time"
            footerView.addSubview(label)
            let imageView = UIImageView(frame: CGRect(x: tableView.bounds.size.width / 3 , y: 0, width: 25, height: 25))
            let image = UIImage(named: "scooter")
            imageView.image = image
            let label2 = UILabel()
            label2.frame = CGRect(x: (tableView.bounds.size.width / 3) + 30  , y: 0, width: tableView.bounds.size.width - 10, height: 24)
            label2.text = "ASAP 55 Mints"
            label2.textColor = UIColor.orange
            footerView.addSubview(label2)
            footerView.addSubview(imageView)
            return footerView
        }
        else {return nil}
        
    }
    
}

struct CustomerType: Codable {
    let id: Int
    let customerType, transID: String
    let customerEmail,customerPassword: String
    let ipAddress: String?
    let orderDate, specialInstructions, customerPhone, customerFirstName: String
    let customerLastName, orderStatus, billingStatus: String
    let printingStatus: String
    let creditStatus, orderType, paymentType, orderTime: String
    let promoCode, sitePreference, paymentGateway, paymentGatewayReference: String?
    let orderConfirmationStatus, orderConfirmationStatusMessage: String
    let deliveryCharge: Int
    let surCharge: String?
    let amount, subTotal: Double
    let orderDiscount: Int
    let promoCodeDiscount, orderCredit: Bool?
    let customerID, branchID, processedBySoftware: Int
    let phoneNotify, sendFax, sendSMS, firstCustomerOrder: Bool
    let preOrdered, companyID: Int
    let customerOrderAddress: String?
    let customerOrderTaxes: [CustomerOrderTax]
    let customerOrderItem: [CustomerOrderItem]
    let invoiceOrderDetailID, cardOption: String
    
    enum CodingKeys: String, CodingKey {
        case id, customerType
        case transID = "transId"
        case customerEmail,customerPassword,ipAddress, orderDate, specialInstructions, customerPhone, customerFirstName, customerLastName, orderStatus, billingStatus, printingStatus, creditStatus, orderType, paymentType, orderTime, promoCode, sitePreference, paymentGateway, paymentGatewayReference, orderConfirmationStatus, orderConfirmationStatusMessage, deliveryCharge, surCharge, amount, subTotal, orderDiscount, promoCodeDiscount, orderCredit
        case customerID = "customerId"
        case branchID = "branchId"
        case processedBySoftware, phoneNotify, sendFax
        case sendSMS = "sendSms"
        case firstCustomerOrder, preOrdered
        case companyID = "companyId"
        case customerOrderAddress, customerOrderTaxes, customerOrderItem, invoiceOrderDetailID, cardOption
    }
}


//struct CustomerOrderTax: Codable {
//    let id: Int
//    let orderType, taxRule, taxLabel: String
//    let rate, taxAmount: Double
//    let chargeMode: Int
//}

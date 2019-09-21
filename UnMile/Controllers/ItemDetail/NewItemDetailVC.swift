//
//  NewItemDetailVC.swift
//  UnMile
//
//  Created by user on 9/2/19.
//  Copyright © 2019 Moghees Sheikh. All rights reserved.


import UIKit
import Alamofire
import AlamofireImage

class NewItemDetailVC: BaseViewController {
    
    
    
    
    @IBOutlet weak var tblOptionGroup: UITableView!
    var product: Product!
    var optionGroup : [String] = []
    var oG :CustomerOptionGroup!
    var optionGroupOptions : Option!
    let mustArray = NSMutableArray.init()
    var optionalArray = NSMutableArray.init()
    var mustCount = 0
    var optionalCount = 0
    var selectedIndex : NSIndexPath?
    var cProduct : CustomerProduct!
    var customerOrderItemOptionObj : CustomerOrderItemOption!
    var customerOrderItemOptionArray : [CustomerOrderItemOption] = []
    var items : CustomerOrderItem?
    let cartBag = SSBadgeButton()
    var bag = 0
    var qNumber = 1
    var qPrice = 0.0
    var selectedSingleRows = [String:IndexPath]()
    var rowsWhichAreChecked = [NSIndexPath]()
    var radioWhichAreChecked = [NSIndexPath.init(row: 0, section: 0)]
    var customerOptionGroupArray : [CustomerOptionGroup] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alreadyItems = getAlreadyCartItems()
        tblOptionGroup.rowHeight = 44
        // Do any additional setup after loading the view.
        tblOptionGroup.register(UINib(nibName: "section1Cell", bundle: Bundle.main), forCellReuseIdentifier: "cell1")
        tblOptionGroup.register(UINib(nibName: "section2Cell", bundle: Bundle.main), forCellReuseIdentifier: "cell2")
        tblOptionGroup.register(UINib(nibName: "section3Cell", bundle: Bundle.main), forCellReuseIdentifier: "cell3")
        tblOptionGroup.register(UINib(nibName: "section4Cell", bundle: Bundle.main), forCellReuseIdentifier: "cell4")
        tblOptionGroup.register(UINib(nibName: "section5Cell", bundle: Bundle.main), forCellReuseIdentifier: "cell5")
        tblOptionGroup.register(UINib(nibName: "section6Cell", bundle: Bundle.main), forCellReuseIdentifier: "cell6")
        for index in product.optionGroups.indices{
            optionGroup.append(product.optionGroups[index].name)
            
        }
        cartBag.frame = CGRect(x: 0, y: 0, width: 25, height: 30)
        cartBag.setImage(UIImage(named: "bag")?.withRenderingMode(.automatic), for: .normal)
        cartBag.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        cartBag.addTarget(self, action: #selector(cartBagTapped), for: .touchUpInside)
        bag = alreadyItems.count
        UserDefaults.standard.set(bag, forKey: "bag")
        cartBag.badge = String(bag)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartBag)]
       
        for group in product.optionGroups{
            if (group.maxChoice <= 1){
                mustCount += 1
            }
            else{
                optionalCount += 1
            }
        }
        print(mustCount,"Moghees",optionalCount)
        
        for i in 0...mustCount-1{
            
            mustArray.add("")
        }
        for i in 0...optionalCount{
            
            optionalArray.add("")
        }
        
    }
    func addSelectedCellWithSection(_ indexPath:IndexPath) ->IndexPath?
    {
        let existingIndexPath = selectedSingleRows["\(indexPath.section)"]
        selectedSingleRows["\(indexPath.section)"]=indexPath;
        return existingIndexPath
    }
    
    func indexPathIsSelected(_ indexPath:IndexPath) ->Bool {
        if let selectedIndexPathInSection = selectedSingleRows["\(indexPath.section)"] {
            if(selectedIndexPathInSection.row == indexPath.row) { return true }
        }
        
        return false
    }

    
    @IBAction func cartBagTapped (_ sender: Any){
        
        performSegue(withIdentifier: "addtoCart", sender: nil)
    }
   
}

extension NewItemDetailVC :  UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section <= 1){
            return 0
        }
        else {
            
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return ""
        }else if (section >= 2 && section<=(product.optionGroups.count+1)){
            return optionGroup[section-2]
        }
        else {
            return ""
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5 + product.optionGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section >= 2 && section<=(product.optionGroups.count+1) {
            return product.optionGroups[section-2].options.count;
            
        }
        else {return 1}
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! section1Cell
                Alamofire.request(product.productPhotoURL ?? "").responseImage { response in
                    if let image = response.result.value {
                        cell.productImg.image = image
                    } else {
                        cell.productImg.image  = UIImage(named: "logo")
                    }
                    
                }
                
                return cell
            }
              
            else if (indexPath.section == 1){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! section2Cell
                cell.subview1.layer.cornerRadius = 5
                cell.descriptionLbl.text = product.description
                cell.price.text = "\(product.price)"
                cell.productName.text = product.name
                return cell
            }
                
            else if (indexPath.section >= 2 && indexPath.section<=(product.optionGroups.count+1)){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! section3Cell

                cell.optionName.text = product.optionGroups[indexPath.section-2].options[indexPath.row].name
                
                cell.optionPrice.text = "\(product.optionGroups[indexPath.section-2].options[indexPath.row].price)"
                if(product.optionGroups[indexPath.section-2].maxChoice <= 1)
                {
                    if(self.indexPathIsSelected(indexPath)) {
                        cell.radio_check_button.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
                        
                    } else {
                        cell.radio_check_button.setImage(UIImage(named: "radio-button-uncheck"),for:UIControl.State.normal)
                    }
                }
                else{
                  
                    if(self.indexPathIsSelected(indexPath)) {
                        
                    cell.radio_check_button.setImage(UIImage(named: "check"),for:UIControl.State.normal)
                    }
                    else {
                        cell.radio_check_button.setImage(UIImage(named: "uncheck"),for:UIControl.State.normal)
                    }
                    
                }
                return cell
            }
                
            else if (indexPath.section == (product.optionGroups.count+2)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! section4Cell
                cell.subview1.layer.cornerRadius = 5
                cell.delegate = self
                
                return cell
            }
            else if (indexPath.section == (product.optionGroups.count+3))  {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell5", for: indexPath) as!section5Cell
                
                return cell
            }
        
            else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell6", for: indexPath) as! section6Cell
                cell.addItemButton.layer.cornerRadius = 5
                cell.delegate = self
                return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let previusSelectedCellIndexPath = self.addSelectedCellWithSection(indexPath)
        
        let cell = self.tblOptionGroup.cellForRow(at: indexPath) as! section3Cell
      
        if (indexPath.section >= 2 && indexPath.section<=(product.optionGroups.count+1)){
            
             if(product.optionGroups[indexPath.section-2].maxChoice <= 1)
                {
                    
                    oG  =  CustomerOptionGroup.init(id: product.optionGroups[indexPath.section-2].id, name: product.optionGroups[indexPath.section-2].name, identifierName: product.optionGroups[indexPath.section-2].identifierName, listQuantity: product.optionGroups[indexPath.section-2].listQuantity, minChoice: product.optionGroups[indexPath.section-2].minChoice, maxChoice: product.optionGroups[indexPath.section-2].maxChoice, status: product.optionGroups[indexPath.section-2].status, archive: product.optionGroups[indexPath.section-2].archive, optID: product.optionGroups[indexPath.section-2].optID, options: [product.optionGroups[indexPath.section-2].options[indexPath.row]])
                    
                    optionGroupOptions =  product.optionGroups[indexPath.section-2].options[indexPath.row]
                    
                    customerOrderItemOptionObj  = CustomerOrderItemOption.init(quantity: customerOptionGroupArray.count, purchaseSubTotal: 0, option: optionGroupOptions, parentOptionGroup: product?.optionGroups[indexPath.section-2], customerOrderItem: items )
                    
                    if(previusSelectedCellIndexPath != nil)
                    {
                let previusSelectedCell = self.tblOptionGroup.cellForRow(at: previusSelectedCellIndexPath!) as! section3Cell
                        previusSelectedCell.radio_check_button.setImage(UIImage(named: "radio-button-uncheck"),for:UIControl.State.normal)
                        selectedIndex = indexPath as NSIndexPath
                        customerOrderItemOptionArray.append(customerOrderItemOptionObj)
                        mustArray.replaceObject(at: indexPath.section-2, with:oG)
                        tblOptionGroup.deselectRow(at: previusSelectedCellIndexPath!, animated: true)
                        
            tblOptionGroup.reloadData()
                }
            else{
                        cell.radio_check_button.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
                            mustArray.replaceObject(at: indexPath.section-2, with:oG)
                        customerOrderItemOptionArray.append(customerOrderItemOptionObj)
                    }
                }
             else {
                let oG  =  CustomerOptionGroup.init(id: product.optionGroups[indexPath.section-2].id, name: product.optionGroups[indexPath.section-2].name, identifierName: product.optionGroups[indexPath.section-2].identifierName, listQuantity: product.optionGroups[indexPath.section-2].listQuantity, minChoice: product.optionGroups[indexPath.section-2].minChoice, maxChoice: product.optionGroups[indexPath.section-2].maxChoice, status: product.optionGroups[indexPath.section-2].status, archive: product.optionGroups[indexPath.section-2].archive, optID: product.optionGroups[indexPath.section-2].optID, options: [product.optionGroups[indexPath.section-2].options[indexPath.row]])
               
                optionGroupOptions =  product.optionGroups[indexPath.section-2].options[indexPath.row]
                
                customerOrderItemOptionObj  = CustomerOrderItemOption.init(quantity: customerOptionGroupArray.count, purchaseSubTotal: 0, option: optionGroupOptions,  parentOptionGroup:product?.optionGroups[indexPath.section-2],customerOrderItem: items)
                
                customerOrderItemOptionArray.append(customerOrderItemOptionObj)
                
                if(rowsWhichAreChecked.contains(indexPath as NSIndexPath) == false){
                    
                   cell.radio_check_button.setImage(UIImage(named: "check"),for:UIControl.State.normal)
                    
                    if((optionalArray[indexPath.section - 2 - mustCount]) is String)
                    {
                    
                        optionalArray[indexPath.section - 2 - mustCount ] = [oG]
                        customerOptionGroupArray += [oG]
                    }
                    else{
                        customerOptionGroupArray[indexPath.section - 2 - mustCount].options.append(contentsOf: oG.options)
                    }
                    rowsWhichAreChecked.append(indexPath as NSIndexPath)
                    tblOptionGroup.deselectRow(at: indexPath, animated: true)
                }
                else{
                    if let checkedItemIndex = rowsWhichAreChecked.index(of: indexPath as NSIndexPath){
                         cell.radio_check_button.setImage(UIImage(named: "uncheck"),for:UIControl.State.normal)
                        if let index = customerOptionGroupArray[indexPath.section - 2 - mustCount].options.index(where: {$0.name == optionGroupOptions.name})
                        {
                            customerOptionGroupArray[indexPath.section - 2 - mustCount].options.remove(at: index)
                        }
                        customerOrderItemOptionArray.remove(at: checkedItemIndex)
                        rowsWhichAreChecked.remove(at: checkedItemIndex)
                        tblOptionGroup.deselectRow(at: indexPath, animated: true)
                    }
                }
            
            }
                    }
    
        }
    
}
extension NewItemDetailVC: radio_Check_ButtonDelegate{
    func didCheckRadioButton(cell: OptionGroupCell) {
        let indexPath = self.tblOptionGroup.indexPath(for: cell)
        
        //let indexPath = self.tblCheckOut.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tblOptionGroup.cellForRow(at: indexPath!) as! section3Cell
        currentCell.radio_check_button.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
        cell.radio_Check_Button.setImage(UIImage(named: "radio-button-uncheck"),for:UIControl.State.normal)
    }
    
    
}

extension NewItemDetailVC: itemDelegate{
    func didPressAddItem(cell: section6Cell) {
        if(mustArray.contains("")){
            showAlert(title: "Selection is missing", message: "Must choose required selection")
        }
        else{
            customerOptionGroupArray += mustArray as! Array<CustomerOptionGroup>
        
        cProduct = CustomerProduct.init(id: product.id, code: product.code, name: product.name, description: product.description, productPhotoURL: product.productPhotoURL ?? "logo", price: Int(product!.price), position: product.position, status: product.status, archive: product.archive, optionGroups: customerOptionGroupArray)
          
        var alreadyItems = getAlreadyCartItems()
        // update existing item in cart
        if alreadyItems.contains(where: { $0.product.name == product.name }) {
            
            for i in alreadyItems.indices {
                if(alreadyItems[i].product.name == product.name){
                    if(alreadyItems[i].quantity == qNumber || alreadyItems[i].quantity! > qNumber ){
                        qNumber = alreadyItems[i].quantity! + 1
//                        alreadyItems[i].quantity = qNumber
                    }
                    
                    alreadyItems[i].quantity = qNumber
                    alreadyItems[i].purchaseSubTotal = Int(qPrice)
                    alreadyItems[i].instructions = "No Instruction"
//                    alreadyItems[i].product.name = product.name
                    alreadyItems[i].customerOrderItemOptions = customerOrderItemOptionArray
  
                }
            }
            saveItems(allItems: alreadyItems)
            
        }
            // add new item in cart
        else{
            items?.quantity = qNumber
            items?.purchaseSubTotal = Int(qPrice)
            items?.instructions = "No Instruction"
            print(String.init(format: "count before adding item is %i", alreadyItems.count))
            totalPrice += qPrice
            //"v1px5bld"
            
            items =  CustomerOrderItem.init(id: 0, orderItemID: "v1px5bld" , forWho: "", instructions: "No Instruction", quantity: qNumber, purchaseSubTotal: Int(totalPrice), product: cProduct, customerOrderItemOptions: customerOrderItemOptionArray )
            
    //            items?.orderItemID = "v1px5bld"
    //                items?.forWho = "moghees"
    //                items?.instructions = "No Instruction"
    //                items?.quantity = qNumber
    //                items?.purchaseSubTotal = Int(totalPrice)
    //                items?.product = cProduct
    //                items?.customerOrderItemOptions = customerOrderItemOptionArray
            alreadyItems.append(items!)
            
            saveItems(allItems: alreadyItems)
            
        }
        
        bag = alreadyItems.count
        UserDefaults.standard.set(bag, forKey: "bag")
        cartBag.badge = String(bag)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartBag)]
    }
        
    }
}

extension NewItemDetailVC : itemPlusMinusDelegate{
    func didTappedAddButton(cell: section4Cell) {
        qNumber += 1
        //qPrice = qPrice + orignalPrice
       cell.quantity.text = String(qNumber)
        //price.text = String(qPrice)
    }
    
    func didTappedMinusButton(cell: section4Cell) {
        if qNumber  > 1 {
            qNumber -= 1
          //  qPrice = qPrice - orignalPrice
            cell.quantity.text = String(qNumber)
           // price.text = String(qPrice)
        }
    }
}
struct CustomerOrder: Codable {
    let id: Int
    let customerType: String
    let transID: String
    let ipAddress, orderDate: String
    let specialInstructions, customerPhone, customerFirstName, customerLastName: String
    let orderStatus: String
    let billingStatus, printingStatus, creditStatus: String?
    let orderType, paymentType, orderTime: String
    let promoCode: String?
    let sitePreference: String?
    let paymentGateway, paymentGatewayReference: String?
    let orderConfirmationStatus: String
    let orderConfirmationStatusMessage: String?
    let deliveryCharge: Double
    let surCharge: Double?
    let amount: Double
    let subTotal: Double
    let orderDiscount, promoCodeDiscount: Double?
    let orderCredit: String?
    let customerID, branchID: Int
    let processedBySoftware: Int?
    let phoneNotify, sendFax, sendSMS, firstCustomerOrder: Bool
    let preOrdered, companyID: Int
    let customerOrderAddress: CustomerOrderAddress
    let customerOrderTaxes: [CustomerOrderTax]
    let customerOrderItem: [CustomerOrderItem]
    let invoiceOrderDetailID, cardOption: String?
    
    enum CodingKeys: String, CodingKey {
        case id, customerType
        case transID = "transId"
        case ipAddress, orderDate, specialInstructions, customerPhone, customerFirstName, customerLastName, orderStatus, billingStatus, printingStatus, creditStatus, orderType, paymentType, orderTime, promoCode, sitePreference, paymentGateway, paymentGatewayReference, orderConfirmationStatus, orderConfirmationStatusMessage, deliveryCharge, surCharge, amount, subTotal, orderDiscount, promoCodeDiscount, orderCredit
        case customerID = "customerId"
        case branchID = "branchId"
        case processedBySoftware, phoneNotify, sendFax
        case sendSMS = "sendSms"
        case firstCustomerOrder, preOrdered
        case companyID = "companyId"
        case customerOrderAddress, customerOrderTaxes, customerOrderItem, invoiceOrderDetailID, cardOption
    }
}

struct CustomerOrderAddress: Codable {
    let id, addressID: Int?
    let customerOrderAddressFields: [AddressField]
    
    enum CodingKeys: String, CodingKey {
        case id
        case addressID = "addressId"
        case customerOrderAddressFields
    }
}

struct CustomerOrderAddressField: Codable {
    let id: Int
    let fieldName, label, fieldValue: String
}

struct CustomerOrderItem: Codable {
    let id: Int
    var orderItemID: String?
    var forWho: String?
    var instructions: String?
    var quantity, purchaseSubTotal: Int?
    var product: CustomerProduct
    var customerOrderItemOptions: [CustomerOrderItemOption]
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderItemID = "orderItemId"
        case forWho, instructions, quantity, purchaseSubTotal, product, customerOrderItemOptions
    }
}

struct CustomerOrderItemOption: Codable {
    //let id : Int
    let quantity, purchaseSubTotal: Int
    let option: Option?
   // let parentOption: Option?
    var parentOptionGroup: OptionGroup?
    var customerOrderItem : CustomerOrderItem?
}

struct Option: Codable {
    let id: Int
    let name: String
    let price, status, archive: Int
}

struct CustomerOptionGroup: Codable {
    let id: Int
    let name, identifierName: String
    let listQuantity, minChoice, maxChoice, status: Int
    let archive, optID: Int
    var options: [Option]
    
    enum CodingKeys: String, CodingKey {
        case id, name, identifierName, listQuantity, minChoice, maxChoice, status, archive
        case optID = "optId"
        case options
    }
}

struct CustomerProduct: Codable {
    let id: Int
    var code, name, description: String
    let productPhotoURL: String
    //let promotionCode: JSONNull?
    let price, position, status, archive: Int
    let optionGroups: [CustomerOptionGroup]
    
    enum CodingKeys: String, CodingKey {
        case id, code, name, description
        case productPhotoURL = "productPhotoUrl"
        case price, position, status, archive, optionGroups
    }
}

struct CustomerOrderTax: Codable {
    let id: Int
    let orderType, taxRule, taxLabel: String
    let rate, taxAmount: Double
    let chargeMode: Int
}



    
    
    


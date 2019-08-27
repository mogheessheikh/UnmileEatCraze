//
//  ItemsDetailVC.swift
//  UnMile
//
//  Created by iMac on 27/02/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class ItemsDetailVC: BaseViewController {
    
    @IBOutlet var itemImage: UIImageView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var discription: UILabel!
    @IBOutlet var quantity: UILabel!
    @IBOutlet var specialInstruction: UITextField!
    @IBOutlet var subview1: UIView!
    @IBOutlet var subview2: UIView!
    @IBOutlet var CartButton: UIButton!
    var bag = 0
    var items : CustomerOrderItem?
    var product: Product!
    var qNumber = 1
    var qPrice = 0.0
    var orignalPrice = 0.0
    var instruction = ""
    var itemName = ""
    var itemPrice = 0
    var pQuantity = 1
    var logoUrl =  ""
    var subTotal = 0.0
    var cProduct : CustomerProduct!
    var cCustomerOptionGroup: CustomerOptionGroup!
    var coption: Option!
    
    let cartBag = SSBadgeButton()
    //var cartvc: CartVC!
//    var orderedItem : OrderItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subview1.layer.cornerRadius = 5
        subview1.layer.masksToBounds = true
        
        subview2.layer.cornerRadius = 5
        subview2.layer.masksToBounds = true
        
        CartButton.layer.cornerRadius = 5
        CartButton.layer.masksToBounds = true
        
        print(product.optionGroups)
    
        productName.text = product.name
        orignalPrice = Double((product.price))
        qPrice = orignalPrice
        price.text = String(qPrice)
        discription.text = product.description
        Alamofire.request(product.productPhotoURL ?? "").responseImage { response in
            if let image = response.result.value {
                self.itemImage.image = image
                
            } else {
                self.itemImage.image  = UIImage(named: "logo")
            }
        
        }
        let alreadyItems = getAlreadyCartItems()
        cartBag.frame = CGRect(x: 0, y: 0, width: 25, height: 30)
        cartBag.setImage(UIImage(named: "bag")?.withRenderingMode(.automatic), for: .normal)
        cartBag.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        cartBag.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        bag = alreadyItems.count
        UserDefaults.standard.set(bag, forKey: "bag")
        cartBag.badge = String(bag)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartBag)]
        // Do any additional setup after loading the view.
    }
    @IBAction func AddQuantity(_ sender: Any) {
      
            qNumber += 1
            qPrice = qPrice + orignalPrice
            quantity.text = String(qNumber)
            price.text = String(qPrice)
    }
    
    @IBAction func MinusQuantity(_ sender: Any) {
          if qNumber  > 1 {
        qNumber -= 1
        qPrice = qPrice - orignalPrice
        quantity.text = String(qNumber)
        price.text = String(qPrice)
        }
    }
    @IBAction func cartButtonTapped(_ sender: Any){
        
        performSegue(withIdentifier: "addtoCart", sender: nil)
        
        
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//
//        if segue.identifier == "addtoCart"
//        {
//            let cartVC = segue.destination as? CartVC
//            cartVC?.totalPrice = totalPrice
//
//        }
//   }
    @IBAction func AddToCart(_ sender: Any) {
        
        
        print(self.instruction)
         var alreadyItems = getAlreadyCartItems()
//        cCustomerOptionGroup = CustomerOptionGroup.init(id: 0, name:"abc" , identifierName: "abc", listQuantity: 1, minChoice: 1, maxChoice: 2, status: 2, archive: 2, optID: 2, options: [coption])
        
   cProduct = CustomerProduct.init(id: product.id, code: product.code, name: product.name, description: product.description, productPhotoURL: product.productPhotoURL!, price: Int(product!.price), position: product.position, status: product.status, archive: product.archive, optionGroups: [])
        
        // update existing item in cart
        if alreadyItems.contains(where: { $0.product.name == product.name }) {
        
            for i in alreadyItems.indices {
                if(alreadyItems[i].product.name == product.name){
                    if(alreadyItems[i].quantity == qNumber || alreadyItems[i].quantity! > qNumber ){
                        qNumber = alreadyItems[i].quantity! + 1
                    alreadyItems[i].quantity = qNumber
                    }
                    else{
                        alreadyItems[i].quantity = qNumber
                    }
                
                     alreadyItems[i].quantity = qNumber
                     alreadyItems[i].purchaseSubTotal = Int(qPrice)
                     alreadyItems[i].instructions = specialInstruction.text ?? "No Instruction"
                     alreadyItems[i].product.name = product.name
                     //alreadyItems[i].customerOrderItemOptions[i].parentOptionGroup = product.optionGroups
                    
                    
                    alreadyItems =  [CustomerOrderItem.init(id: 0, orderItemID: "", forWho: "", instructions: specialInstruction.text, quantity: qNumber, purchaseSubTotal: Int(totalPrice), product: (cProduct ?? nil)!, customerOrderItemOptions: [])]
                }
            }
            saveItems(allItems: alreadyItems)

        }
            // add new item in cart
        else{
            items?.quantity = qNumber
            items?.purchaseSubTotal = Int(qPrice)
            items?.instructions = specialInstruction.text ?? "No Instruction"
            print(String.init(format: "count before adding item is %i", alreadyItems.count))
            totalPrice += qPrice
            items =  CustomerOrderItem.init(id: 0, orderItemID: "", forWho: "", instructions: specialInstruction.text, quantity: qNumber, purchaseSubTotal: Int(totalPrice), product: cProduct, customerOrderItemOptions: [])
            
            alreadyItems.append(items!)
            
            saveItems(allItems: alreadyItems)

        }
        
        bag = alreadyItems.count
        UserDefaults.standard.set(bag, forKey: "bag")
        cartBag.badge = String(bag)
        //cartBag.badgeEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 15)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartBag)]
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
    let orderItemID: String?
    let forWho: String?
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
    let id, quantity, purchaseSubTotal: Int
    let option: Option
    let parentOption: String?
    var parentOptionGroup: CustomerOptionGroup
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
    let options: [Option]

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



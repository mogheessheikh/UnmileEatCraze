//
//  ItemDetailOptionGroupsVC.swift
//  UnMile
//
//  Created by iMac  on 08/08/2019.
//  Copyright © 2019 Moghees Sheikh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ItemDetailOptionGroupsVC: BaseViewController {
    
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
    @IBOutlet weak var tblOptionGroup: UITableView!
    let cartBag = SSBadgeButton()
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
    
    @IBAction func cartButtonTapped(_ sender: Any){
        
        performSegue(withIdentifier: "addtoCart", sender: nil)
        
        
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
extension ItemDetailOptionGroupsVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.optionGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OptionGroupCell else {
            fatalError("Unknown cell")
            
        }
        cell.lblOptionGroupName.text = product.optionGroups[indexPath.row].identifierName
        cell.lblOptionGroupValue.text = "\(product.optionGroups[indexPath.row].listQuantity)"
    return cell
    }
}

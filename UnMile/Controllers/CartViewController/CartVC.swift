//
//  CartVC.swift
//  UnMile
//
//  Created by iMac on 04/03/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class CartVC: BaseViewController{
    
    var itemPrice = 0.0
    var itemTotalPrice = 0.0
    var logoUrl = ""
    var itemName = ""
    var subTotal = 0.0
    var instruction = ""
    var quantity = 1
    var items: Product!
    //var items : OrderItem!
    
    var allItems : [CustomerOrderItem]!
    var addMoreItems : [CustomerOrderItem]!
    @IBOutlet var lblTotalPrice: UILabel!
    @IBOutlet var addItems: UIButton!
    @IBOutlet var tblCart: UITableView!
    @IBOutlet var checkOut: UIButton!
    
    //var items: ItemsDetailVC = ItemsDetailVC(nibName: nil, bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allItems = getAlreadyCartItems()
        subTotal = getTotalPriceFromCart()
        lblTotalPrice.text = "Grand Total : \(subTotal)"
        addItems.layer.borderWidth = 1
        addItems.layer.cornerRadius = 7
        checkOut.layer.cornerRadius = 7
        addItems.layer.borderColor = UIColor.green.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if allItems.count != 0
        {
            UserDefaults.standard.set(allItems.count , forKey: "Bag")
            
        }
        else{
            UserDefaults.standard.removeObject(forKey: "Bag")
        }
        tblCart.reloadData()
        if(allItems.count == 0){
            //            checkOut.isEnabled = false
            //            checkOut.isUserInteractionEnabled = false
            checkOut.isHidden = true
        }
        else{
            checkOut.isHidden =  false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cart2checkout"{
            
            
            let checkOut = segue.destination as? CheckOutVC
            checkOut?.totalprice = totalPrice
        }
        
    }
    @IBAction func addMoreItems(_ sender: Any) {
        
        performSegue(withIdentifier: "Cart2Restaurant", sender: nil)
    }
    
    @IBAction func checkOut(_ sender: Any) {
       
       if tblCart.visibleCells.isEmpty {
        showAlert(title: "Cart is empty", message: "Add Items in card to continue")
        }
       else{
        branchCheck = getBranchObject(key: "SavedBranch")
        
       
        if  branchCheck?.isOpen == true
        {
            if UserDefaults.standard.object(forKey: "customerName") != nil{
                let urlArray = allItems.map({ $0.id })
                let urlSet = Set(urlArray)
                print(urlSet)
                performSegue(withIdentifier: "cart2checkout", sender: nil)
                
                
            }
            else{
                
                showAlert(title: "You Are is Not Loged in", message: "You must loged in to continue")
            }
        }
        else{
           showAlert(title: "Branch Is Close", message: "Can't Place Order When Branch Is Close")
            
        }
        }
     
    }
}

extension CartVC: plusMinusDelegate{
    
    func didTappedAddButton(cell: CartTableViewCell) {
        addMoreItems = getAlreadyCartItems()
        var indexPath = self.tblCart.indexPath(for: cell)
        
        itemPrice = Double(addMoreItems[(indexPath?.row)!].product.price)
        quantity = addMoreItems[(indexPath?.row)!].quantity!
           quantity += 1
            itemTotalPrice = itemPrice * Double(quantity)
            totalPrice = totalPrice + itemPrice
        cell.Quantity.text = "\(quantity)"
        cell.TotalPrice.text = "Total Price: \(itemTotalPrice)"
        lblTotalPrice.text = "Grand Total : \(totalPrice)"
        addMoreItems[(indexPath?.row)!].quantity = quantity
        addMoreItems[(indexPath?.row)!].purchaseSubTotal = Int(totalPrice)
        
        saveItems(allItems: addMoreItems )
    
    }
    
    func didTappedMinusButton(cell: CartTableViewCell) {
        var indexPath = self.tblCart.indexPath(for: cell)
        addMoreItems = getAlreadyCartItems()
       
        quantity = addMoreItems[indexPath!.row].quantity!
        itemPrice = Double(addMoreItems[indexPath!.row].product.price)
        
        if quantity  > 1 {
            quantity -= 1
          itemTotalPrice = itemPrice * Double(quantity)
            totalPrice = totalPrice - itemPrice
        cell.Quantity.text = "\(quantity)"
        cell.TotalPrice.text = "Total Price: \(itemTotalPrice)"
        lblTotalPrice.text = "Grand Total : \(totalPrice)"
            addMoreItems[(indexPath?.row)!].quantity = quantity
            addMoreItems[(indexPath?.row)!].purchaseSubTotal = Int(totalPrice)
            saveItems(allItems: addMoreItems )
        }
        
    }
    
    
    
}
extension CartVC : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return items.quantity ?? 1
        return allItems.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartTableViewCell
        cell.delegate = self
        let items = allItems[indexPath.row]
        
        cell.ItemPrice.text = "Price:\(items.product.price )"//String(items.itemPrice)//
        
       // totalPrice += items.price
        
        Alamofire.request(items.product.productPhotoURL ?? "").responseImage { response in
            if let image = response.result.value {
                cell.ProductImage.image = image
                
            } else {
                cell.ProductImage.image = UIImage(named: "logo")
            }
        }
        cell.ProductName.text = items.product.name//itemName
        cell.TotalPrice.text = "Total Price:\(items.product.price * (items.quantity!))"//String(items.subTotal)//
        cell.SpecialInstruction.text = "Special Instructions:\(items.instructions ?? "No Instruction")"//items.instruction//
        cell.Quantity.text = " \(items.quantity ?? 1)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let alreadyItems = NSMutableArray.init(array: getAlreadyCartItems())
            if (alreadyItems.count != 0){
                alreadyItems.removeObject(at: indexPath.row)
                allItems.remove(at: indexPath.row)
                self.tblCart.deleteRows(at: [indexPath] , with: .fade)
                //tblCart.beginUpdates()

                saveItems(allItems: alreadyItems as! [CustomerOrderItem])
                 lblTotalPrice.text = "Grand Total : \(getTotalPriceFromCart())"
                tblCart.reloadData()
                // tblCart.endUpdates()
                if let tabItems = tabBarController?.tabBar.items {
                    
                    let tabItem = tabItems[1]
                    tabItem.badgeValue = "0"
                    
                    UserDefaults.standard.set(allItems.count , forKey: "Bag")
                    if let cartBag = UserDefaults.standard.object(forKey: "Bag"){
                        
                        tabItem.badgeValue = "\(cartBag)"
                        print(cartBag)
                    }
                    else{
                        
                        tabItem.badgeValue = "0"
                    }
                }
            }
        }
    }
}

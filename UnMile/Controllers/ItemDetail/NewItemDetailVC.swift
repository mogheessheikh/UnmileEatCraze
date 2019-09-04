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
    var selectedIndex : NSIndexPath?
    var cProduct : CustomerProduct!
    var items : CustomerOrderItem?
    let cartBag = SSBadgeButton()
    var bag = 0
    var qNumber = 1
    var qPrice = 0.0
    
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
                
                cell.descriptionLbl.text = product.description
                cell.price.text = "\(product.price)"
                cell.productName.text = product.name
                return cell
            }
                
            else if (indexPath.section >= 2 && indexPath.section<=(product.optionGroups.count+1)){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath) as! section3Cell

                cell.optionName.text = product.optionGroups[indexPath.section-2].options[indexPath.row].name
                
                cell.optionPrice.text = "\(product.optionGroups[indexPath.section-2].options[indexPath.row].price ?? 0.0)"
                if(product.optionGroups[indexPath.section-2].maxChoice <= 1)
                {
                    if (selectedIndex == indexPath as NSIndexPath ) {
                        cell.radio_check_button.setImage(UIImage(named: "radio-button-check"),for:UIControl.State.normal)
                    } else {
                        cell.radio_check_button.setImage(UIImage(named: "radio-button-uncheck"),for:UIControl.State.normal)
                    }
                }
                else{
                    cell.radio_check_button.setImage(UIImage(named: "uncheck"),for:UIControl.State.normal)
                }
                return cell
            }
                
            else if (indexPath.section == (product.optionGroups.count+2)){
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell4", for: indexPath) as! section4Cell
                
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
}
extension NewItemDetailVC: itemDelegate{
    func didPressAddItem(cell: section6Cell) {
       
        cProduct = CustomerProduct.init(id: product.id, code: product.code, name: product.name, description: product.description, productPhotoURL: product.productPhotoURL ?? "logo", price: Int(product!.price), position: product.position, status: product.status, archive: product.archive, optionGroups: [])
        
        var alreadyItems = getAlreadyCartItems()
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
                    alreadyItems[i].instructions = "No Instruction"
                    alreadyItems[i].product.name = product.name
                    alreadyItems =  [CustomerOrderItem.init(id: 0, orderItemID: "", forWho: "", instructions:"No Instruction", quantity: qNumber, purchaseSubTotal: Int(totalPrice), product: (cProduct ?? nil)!, customerOrderItemOptions: [])]
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
            items =  CustomerOrderItem.init(id: 0, orderItemID: "", forWho: "", instructions: "No Instruction", quantity: qNumber, purchaseSubTotal: Int(totalPrice), product: cProduct, customerOrderItemOptions: [])
            
            alreadyItems.append(items!)
            
            saveItems(allItems: alreadyItems)
            
        }
        
        bag = alreadyItems.count
        UserDefaults.standard.set(bag, forKey: "bag")
        cartBag.badge = String(bag)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: cartBag)]
    }
        
    
}
    
    
    


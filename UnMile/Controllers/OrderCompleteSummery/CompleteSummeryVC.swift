//
//  CompleteSummeryVC.swift
//  UnMile
//
//  Created by iMac  on 27/06/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

class CompleteSummeryVC: BaseViewController {

    
    var sectionTitle = ["","Route","Order Summery","Detail","Contact Support"]
    var sectionOneArrayTitle = ["Sub Total","Sur Charge","GST","Discount","Order Number", "Order Time"]
    var sectionOneArrayValue:[String]!
    var routeLogo: [UIImage] = [UIImage(named: "restaurant")! , UIImage(named: "location1")!]
    var routeArray:[String]!
    var restuarentAddress: String!
    var itemSummery : [CustomerOrderItem]!
    @IBOutlet weak var tblCompleteSummery: UITableView!
    var orderSummery: CustomerOrder!
    var branch: Branch!
   
    var customerOrder: CustomerOrder!
    override func viewDidLoad() {
        
        super.viewDidLoad()
       hideNavigationBar()
        
         itemSummery = getAlreadyCartItems()
        
        tblCompleteSummery.register(UINib(nibName: "Route", bundle: Bundle.main), forCellReuseIdentifier: "routecell")
        tblCompleteSummery.register(UINib(nibName: "OrderItemsSummery", bundle: Bundle.main), forCellReuseIdentifier: "itemcell")
        tblCompleteSummery.register(UINib(nibName: "OrderDetail", bundle: Bundle.main), forCellReuseIdentifier: "detailcell")
        tblCompleteSummery.register(UINib(nibName: "ContactSupport", bundle: Bundle.main), forCellReuseIdentifier: "contactcell")
       
        
        
        if let customerOrderSummery = UserDefaults.standard.object(forKey: "savedCustomerOrder") as? Data  {
            let decoder = JSONDecoder()
            customerOrder = try? decoder.decode(CustomerOrder.self, from: customerOrderSummery)
               orderSummery = customerOrder
            
        }
        
        if let savedBranch = UserDefaults.standard.object(forKey: "branchAddress") as? Data  {
            let decoder = JSONDecoder()
            branch = try! decoder.decode(Branch.self, from: savedBranch)
               restuarentAddress  = branch.addressLine1
            
        }
        sectionOneArrayValue = ["\(orderSummery.subTotal)","\(orderSummery.surCharge)","\(orderSummery.customerOrderTaxes[0].taxAmount)","\(orderSummery.orderDiscount)","\(orderSummery.id)","\(orderSummery.orderDate)"]
        routeArray = ["\(restuarentAddress ?? "")","\(orderSummery.customerOrderAddress.customerOrderAddressFields[0].fieldValue + orderSummery.customerOrderAddress.customerOrderAddressFields[1].fieldValue + orderSummery.customerOrderAddress.customerOrderAddressFields[2].fieldValue + orderSummery.customerOrderAddress.customerOrderAddressFields[3].fieldValue)"]
        
    }
    
    
    @IBAction func goToMain(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey:"savedCustomerOrder")
        UserDefaults.standard.removeObject(forKey:"branchAddress")
        UserDefaults.standard.removeObject(forKey:"SavedBranch")
        
        let alreadyItems = NSMutableArray.init(array: self.getAlreadyCartItems())
        if (alreadyItems.count != 0){
            alreadyItems.removeAllObjects()
            self.saveItems(allItems: alreadyItems as! [CustomerOrderItem])
        }
        if let tabbarVC = Storyboard.main.instantiateViewController(withIdentifier: "TabbarController") as? UITabBarController,
            let nvc = tabbarVC.viewControllers?[0] as? UINavigationController,
            let _ = nvc.viewControllers[0] as? MainVC {
            
            UIApplication.shared.keyWindow!.replaceRootViewControllerWith(tabbarVC, animated: true, completion: nil)
    }
    
}
}
extension CompleteSummeryVC : UITableViewDataSource,UITableViewDelegate{
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 2 && indexPath.row == 1 || indexPath.section == 3)
        {
            return 100
        }
        else {return 60}
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {

           guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? orderCompleteStaticCell
            else {
                fatalError("Unknown cell")
            }
            cell.lblANTD.text = sectionOneArrayTitle[indexPath.row]
            cell.lblANTDValues.text = sectionOneArrayValue[indexPath.row]
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
            
            cell.lblPaymentType.text =  orderSummery.paymentType
            cell.lblInstruction.text = "\(orderSummery.specialInstructions)"
            cell.lblDeliveryTime.text = "minimum 50-75 mints"
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


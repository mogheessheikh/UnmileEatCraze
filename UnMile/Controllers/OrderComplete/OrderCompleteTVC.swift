//
//  OrderCompleteTVC.swift
//  UnMile
//
//  Created by iMac on 18/04/2019.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import AlamofireImage

class OrderCompleteTVC: UITableViewController {

    @IBOutlet var tblDynamicCell: UITableView!
    @IBOutlet var tblOrderComplete: UITableView!
    @IBOutlet var lblFinalAmmount: UILabel!
    @IBOutlet var lblOrderNumber: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblRestuarentAddress: UILabel!
    @IBOutlet var lblCustomer: UILabel!
    @IBOutlet var lblPaymentType: UILabel!
    @IBOutlet var lblInstruction: UILabel!
    
    var sectionTitle = ["","Route","Order Summery","Detail","Contact Support"]
    var itemSummery : [CustomerOrderItem]!
    var totalPrice = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemSummery = getAlreadyCartItems()
        
      
            print(totalPrice)
        
        tableView.delegate = self
        tableView.dataSource = self
      //  tblDynamicCell.dataSource = UITableViewDataSource
    //tblDynamicCell.delegate = UITableViewDelegate
   //  tblOrderComplete.register(UINib(nibName: "OrderSummeryCell", bundle: Bundle.main), forCellReuseIdentifier: "summery")
        
        
        lblFinalAmmount.text = "\(getTotalPriceFromCart())"
        lblDate.text = currentDateTime()
        if let savedBranch = UserDefaults.standard.object(forKey: "branchAddress") as? Data  {
            let decoder = JSONDecoder()
            if let loadedBranchAddress = try? decoder.decode(Branch.self, from: savedBranch) {
           lblRestuarentAddress.text = loadedBranchAddress.addressLine1
            }
            
            
        }
    }

    func currentDateTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
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
                
                totalPrice += (Double((itemBac?.product.price)!) * (Double((itemBac?.quantity)!)))
                
                
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return totalPrice
    }
    // MARK: - Table view data source

    @objc  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        
        return sectionTitle.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 2)
        {
           return itemSummery.count
            
        }
         else{return 1}
    }

    @objc override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    @objc override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

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
    @objc override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
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
    @objc override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 2 )
        {
            let cell = self.tblDynamicCell.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DynamicCell
             let items = itemSummery[indexPath.row]
            cell.lblItems.text = items.product.name
            cell.lblPrice.text = "\(items.product.price)"
            cell.lblQuantity.text = "\(items.quantity ?? 0)"
           return cell  
        }
        else{
            //let cell = self.tblOrderComplete.dequeueReusableCell(withIdentifier: "StaticCell1", for: indexPath) as? StaticCell
            //let items = itemSummery[indexPath.row]
            
            return  super.tableView(tableView, cellForRowAt: indexPath)
        }
        
    }

  @objc override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.section == 2 && indexPath.row == 1 || indexPath.section == 3)
        {
            
            return 100
        }
        else {return 44}
    }
  
}

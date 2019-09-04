//
//  RestaurantsVC.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/21/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantsVC: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var companyId = 0
    var countryId = "7"
    var city = ""
    var area = ""
    private var branchListResponse: BranchListResponse!
    private var branches = [BranchWrapperAppList]()
    var companyDetails: CompanyDetails!
    var pageNo = "1"
    var zoneType = ""
    
    private var didTapDeleteKey = false

    override func viewDidLoad() {
        super.viewDidLoad()
        startActivityIndicator()
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self

       
        showNavigationBar()
        if let savedCompany = UserDefaults.standard.object(forKey: "SavedCompany") as? Data  {
            let decoder = JSONDecoder()
            if let loadedCompany = try? decoder.decode(CompanyDetails.self, from: savedCompany) {
                zoneType = loadedCompany.deliveryZoneType.name
                let area =  getSavedAreaObject(key: "SavedArea")
                if(area != nil){
                    
                    title = area!.area + "/Restaurants"
                    
                    let city = getSavedCityObject(key: "SavedCity")
                    
                    getRestaurantsBy(countryId: self.countryId, companyId: "\(loadedCompany.id)" , type: zoneType , city: city.name, area: area!.area, pageNo: self.pageNo)
                    
                }
                else {
                    
                    showAlert(title: "Select city / Area", message: "You havn't select City/Area")
                }
                
            }
            
            
        }
        else{
             title = area + "/Restaurants"
            zoneType = companyDetails.deliveryZoneType.name
            getRestaurantsBy(countryId: self.countryId, companyId: "\(companyId)" , type: zoneType, city: city, area: area, pageNo: self.pageNo)
        }
        }

    func getRestaurantsBy(countryId: String, companyId: String = "", type: String = "", city: String = "", area: String = "", pageNo: String = "1", pageSize: String = "100", name: String = "", cuisine: String = "") {

        let params: [String : Any] = ["countryID":countryId,
                                      "companyID": companyId,
                                      "type": zoneType,
                                      "city":city,
                                      "area": area,
                                      "pageNo": pageNo,
                                      "pageSize":pageSize,
                                      "name": name,
                                      "cuisine": cuisine]

        NetworkManager.getDetails(path: Path.branchUrl + "/by-params-app", params: params, success: { (json, isError) in

            self.view.endEditing(true)

            do {
                let jsonData =  try json.rawData()
                self.branchListResponse = try JSONDecoder().decode(BranchListResponse.self, from: jsonData)
                
                if self.pageNo == "1" {
                    self.branches = (self.branchListResponse.branchWrapperAppList)
                } else {
                    self.branches = self.branches + self.branchListResponse.branchWrapperAppList
                }
              
                self.tableView.reloadData()
                print(self.branchListResponse)
                self.saveBranchWrapper(Object: self.branches, key: "saveBranchWrapper")
                self.stopActivityIndicator()

            } catch let myJSONError {
                print(myJSONError)
                self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
            }

        }) { (error) in
            //self.dismissHUD()
            self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Restaurant2Detail" {
            if let branch = sender as? BranchWrapperAppList,
                let detailVC = segue.destination as? RestaurantDetailVC {
                detailVC.branch = branch
            }
        }
    }
    
    
}

extension RestaurantsVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.pageNo = "1"
        getRestaurantsBy(countryId: self.countryId, companyId: "\(self.companyId)" , type: self.companyDetails.deliveryZoneType.name, city:self.city, area: self.area, pageNo: self.pageNo, name: searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        didTapDeleteKey = text.isEmpty

        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !didTapDeleteKey && searchText.isEmpty {
            self.pageNo = "1"
            getRestaurantsBy(countryId: self.countryId, companyId: "\(self.companyId)" , type: self.companyDetails.deliveryZoneType.name, city:self.city, area: self.area, pageNo: self.pageNo)
        }

        didTapDeleteKey = false
    }
}

extension RestaurantsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantsCell.identifier, for: indexPath) as? RestaurantsCell else {
            fatalError("Unknown cell")
        }

        let branch = branches[indexPath.row]
        cell.name.text = branch.name
        cell.cuisineTypes.text = branch.cuisineTypes.joined(separator: ", ")
        cell.minimumOrder.text = "Minimum Order: " + branch.minOrderAmount

        cell.isOpen.text =  branch.isOpen ? "Open" : "Closed"
        cell.isOpen.backgroundColor = branch.isOpen ? UIColor.initWithHex(hex: "669900") : .red

        if let urlString = branch.locationWebLogoURL,
            let url = URL(string: urlString) {
            cell.restaurantImage.af_setImage(withURL: url, placeholderImage: UIImage(), imageTransition: .crossDissolve(1), runImageTransitionIfCached: false)
        }

        cell.serviceImage1.isHidden = !branch.services.contains(Service.delivery)
        cell.serviceImage2.isHidden = !branch.services.contains(Service.collection)

        if branch.paymentTypes.contains(PaymentType.card) {
            cell.serviceImage3.image = UIImage(named: "card")
        } else {
            cell.serviceImage3.image = UIImage(named: "cash")
        }

        cell.serviceImage3.tintColor = UIColor.initWithHex(hex: "FFA10E")

        cell.discountLabel.text = branch.discountRules.joined(separator: "\n")
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude 
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let branch = branches[indexPath.row]
        let alreadyCartItems = NSMutableArray.init(array: getAlreadyCartItems())
        if let savedBranch = UserDefaults.standard.object(forKey: "SavedBranch") as? Data  {
            let decoder = JSONDecoder()
            if let loadedBranch = try? decoder.decode(BranchWrapperAppList.self, from: savedBranch) {
                if loadedBranch.id != branch.id && alreadyCartItems.count != 0 {
                    
                   deleteFromCartAlert(title: "Can't Change Restuarent", message: "Do you want to remove Itemsfrom cart?")
                }
                else{
                    performSegue(withIdentifier: "Restaurant2Detail", sender: branch)
        
                }
            }
        }
        else{
             saveBranchObject(Object: branch, key: "SavedBranch")
             performSegue(withIdentifier: "Restaurant2Detail", sender: branch)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if self.branches.count > 0 && branchListResponse.hasNext == true && indexPath.row == self.branches.count - 1  {

            guard let increasedPageNumber = Int(self.pageNo) else {
                fatalError("Error")
            }

            print("Branches:\(branches.count)\nhasNext:\(branchListResponse.hasNext)\nIndexPathRow:\(indexPath.row)\nPageNo:\(self.pageNo)")

            self.pageNo = "\(increasedPageNumber + 1)"

            getRestaurantsBy(countryId: self.countryId, companyId: "\(companyId)" , type: companyDetails.deliveryZoneType.name, city: city, area: area, pageNo: self.pageNo)

        }
    }
}

struct BranchListResponse: Codable {
    let hasNext: Bool?
    let totalStores: Int?
    let branchWrapperAppList: [BranchWrapperAppList]
}

struct BranchWrapperAppList: Codable {
    let id: Int
    let name: String
    let locationWebLogoURL: String?
    let cuisineTypes: [String]
    let services: [Service]
    let paymentTypes: [PaymentType]
    let discountRules: [String]
    let minOrderAmount: String
    let isOpen: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case locationWebLogoURL = "locationWebLogoUrl"
        case cuisineTypes, services, paymentTypes, discountRules, minOrderAmount
        case isOpen = "open"
    }
}

enum PaymentType: String, Codable {
    case card = "CARD"
    case cash = "CASH"
}

enum Service: String, Codable {
    case collection = "COLLECTION"
    case delivery = "DELIVERY"
    case cash = "CASH"
}

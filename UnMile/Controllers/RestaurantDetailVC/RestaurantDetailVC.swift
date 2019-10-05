//
//  RestaurantDetailVC.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/31/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantDetailVC: BaseViewController {

    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var isOpen: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cuisineLabel: UILabel!
    @IBOutlet weak var minimumOrderLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var serviceImage1: UIImageView!
    @IBOutlet weak var serviceImage2: UIImageView!
    @IBOutlet weak var serviceImage3: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var product : Product!

    var branchDetails: BranchDetailsResponse!
    var branch: BranchWrapperAppList!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let urlString = branch.locationWebLogoURL,
            let url = URL(string: urlString) {

            restaurantImage.af_setImage(withURL: url, placeholderImage: UIImage(), imageTransition: .crossDissolve(1), runImageTransitionIfCached: false)
        }

        isOpen.text =  branch.isOpen ? "Open" : "Closed"
        isOpen.backgroundColor = branch.isOpen ? UIColor.initWithHex(hex: "669900") : .red
        nameLabel.text = branch.name
        cuisineLabel.text = branch.cuisineTypes.joined(separator: ", ")
        minimumOrderLabel.text = "Minimum Order: " + branch.minOrderAmount

        serviceImage1.isHidden = !branch.services.contains(Service.delivery)
        serviceImage2.isHidden = !branch.services.contains(Service.collection)

        if branch.paymentTypes.contains(PaymentType.card) {
            serviceImage3.image = UIImage(named: "card")
        } else {
            serviceImage3.image = UIImage(named: "cash")
        }

        serviceImage1.tintColor = UIColor.initWithHex(hex: "FFA10E")
        serviceImage2.tintColor = UIColor.initWithHex(hex: "FFA10E")
        serviceImage3.tintColor = UIColor.initWithHex(hex: "FFA10E")

        discountLabel.text = branch.discountRules.joined(separator: "\n")
        title = branch.name
        tableView.dataSource = self
        tableView.delegate = self
        startActivityIndicator()
        getBranchDetail()
        
    
    }

    func getBranchDetail() {

        let path = Path.menuUrl + "/active-by-branchId/" + "\(branch.id)"
        print(path)
        
            NetworkManager.getDetails(path: path, params: nil, success: { (json, isError) in

            do {
                let jsonData =  try json.rawData()
                self.branchDetails = try JSONDecoder().decode(BranchDetailsResponse.self, from: jsonData)
                
                self.saveBranchAddress(Object: self.branchDetails.branch, key: "branchAddress")
                
                self.tableView.reloadData()
                print(self.branchDetails)
                self.stopActivityIndicator()
            } catch let myJSONError {

                #if DEBUG
                self.showAlert(title: "Error", message: myJSONError.localizedDescription)
                #endif

                print(myJSONError)
                self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
            }

        }) { (error) in
            //self.dismissHUD()
            self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
        }
    }

//    @IBAction func AddItem(_ sender: Any) {
//        performSegue(withIdentifier: "AddToCart", sender: self)
//        product = branchDetails.categories[1].products[1]
//        
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "newName"){
            let vc = segue.destination as? NewItemDetailVC
            vc?.product = self.product
        }
    }
    @IBAction func segementDidChange(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    
    /*
     // MARK: - Navigation

     @IBAction func AddItemtoCart(_ sender: Any) {
     }
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension RestaurantDetailVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return branchDetails?.categories.count ?? 0
        } else {
            return branchDetails == nil ? 0 : 2
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return branchDetails?.categories[section].products.count ?? 0
        } else {
            if section == 0 {
                return branchDetails.branch.dayOpeningTimes.filter({ aTime in
                    aTime.orderType.name == "DELIVERY"//COLLECTION
                }).count
            } else {
                return branchDetails?.branch.deliveryZones.count ?? 0
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if self.segmentedControl.selectedSegmentIndex == 0 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDetailCell.identifier, for: indexPath) as? RestaurantDetailCell else {
                fatalError("Unknown cell")
            }

            let product = branchDetails.categories[indexPath.section].products[indexPath.row]
            cell.name.text = product.name
            cell.descriptionLabel.text = product.description
            cell.delegate = self
            if product.price != 0.0 {
                cell.priceLabel.isHidden = false
                cell.priceLabel.text = " PKR \(product.price) "
            }

            if let urlString = product.productPhotoURL,
                let url = URL(string: urlString) {

                print(urlString)

                cell.restaurantImage.af_setImage(withURL: url, placeholderImage: UIImage(), imageTransition: .crossDissolve(1), runImageTransitionIfCached: false)
            }

            return cell
        } else {

            if indexPath.section == 0 {

                guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDayOpeningCell.identifier, for: indexPath) as? RestaurantDayOpeningCell else {
                    fatalError("Unknown cell")
                }

                let dayOpeningTimes = branchDetails.branch.dayOpeningTimes.filter({ aTime in
                    aTime.orderType.name == "DELIVERY"
                })

                let dayOpeningTime = dayOpeningTimes[indexPath.row]

                cell.dayLabel.text = WeekDay(rawValue: dayOpeningTime.day)?.day()

                let timeSlots = dayOpeningTime.dayTimeSlots

                var completeTime = ""
                for i in 0..<timeSlots.count {

                    completeTime =  i>0 ? completeTime + "\n" : completeTime

                    let timeSlot = timeSlots[i]
                    completeTime = completeTime + String(format: "%02d:%02d - %02d:%02d", timeSlot.startHour, timeSlot.startMinute, timeSlot.closingHour, timeSlot.closingMinute)
                }
                cell.timeLabel.text = completeTime

                return cell

            } else {

                guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantDeliveryZonesCell.identifier, for: indexPath) as? RestaurantDeliveryZonesCell else {
                    fatalError("Unknown cell")
                }

                let deliveryZone = branchDetails.branch.deliveryZones[indexPath.row]
                let city = deliveryZone.city.city
                let area = deliveryZone.area.area
                
                cell.nameLabel.text = area + "/" + city
                cell.deliveryFee.text = "PKR\n\(deliveryZone.deliveryFee)"
                cell.minimumDelivery.text = "PKR\n\(deliveryZone.minimumDelivery)"

                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            return branchDetails.categories[section].name
        } else {
            if section == 0 {
                return "OPENING TIMES"
            } else {
                return "DELIVERY ZONES"
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          product = branchDetails.categories[indexPath.section].products[indexPath.row]
          //saveSelectedProduct(Object: product, key: "selectedProduct")
          //performSegue(withIdentifier: "optionGroupVC", sender: self)
        performSegue(withIdentifier: "newName", sender: self)
    }
}

extension RestaurantDetailVC : addItemDelegate{
    
    func didTappedAddButton(cell: RestaurantDetailCell) {
        
        let indexPath = self.tableView.indexPath(for: cell)
        product = branchDetails.categories[indexPath!.section].products[indexPath!.row]
        //performSegue(withIdentifier: "optionGroupVC", sender: self)
        performSegue(withIdentifier: "newName", sender: self)
        
    }
}

struct BranchDetailsResponse: Codable {
    let id: Int
    let name, descriptionValue: String
    let status, archive: Int
    let branch: Branch
    let categories: [Category]

    enum CodingKeys: String, CodingKey {
        case id, name
        case descriptionValue = "description"
        case status, archive, branch, categories
    }
}

struct Branch: Codable {
    let id: Int
    let name, urlPath, phone, fax: String
    let postCode, addressLine1, addressLine2, town: String
    let city, county, country: String
    let locationWebLogoURL: String?
    let emailOrder, emailClient1, emailClient2, emailClient3: String
    //    let emailClientCC, smsClient: String
    let orderConfirmation, clientSendSMS, clientSendMail, clientSendFax: Int
    let clientPhoneNotify, encryptPassword, automaticPrinting, defaultBranch: Int
    let featureBranch: Int
    let timeZone: String
    let score, status, archive: Int
    let orderConfirmationSetting: String
    let outsourcedDelivery: Int
    let branchType: BranchType
    let paymentMethods: [PaymentMethod]?
    let services: [BranchDetailService]
    let taxes: [Tax]
    let orderDiscountRules: [OrderDiscountRule]
    let promoCodeDiscountRules: [PromoCodeDiscountRule]
    let dayOpeningTimes: [DayOpeningTime]
    let deliveryZones: [DeliveryZone]
    let cuisineTypes: [CuisineType]

    enum CodingKeys: String, CodingKey {
        case id, name, urlPath, phone, fax, postCode, addressLine1, addressLine2, town, city, county, country
        case locationWebLogoURL = "locationWebLogoUrl"
        case emailOrder, emailClient1, emailClient2, emailClient3
        //        case emailClientCC, smsClient
        case orderConfirmation
        case clientSendSMS = "clientSendSms"
        case clientSendMail, clientSendFax, clientPhoneNotify, encryptPassword, automaticPrinting, defaultBranch, featureBranch, timeZone, score, status, archive, orderConfirmationSetting, outsourcedDelivery, branchType, paymentMethods, services, taxes, dayOpeningTimes, deliveryZones, cuisineTypes,orderDiscountRules,promoCodeDiscountRules     
    }
}

struct BranchType: Codable {
    let id: Int
    let name: String
}

struct CuisineType: Codable {
    let id: Int
    let name: String
    let status, archive: Int
    let createdate: String?
    let price: Double?
}

struct DayOpeningTime: Codable {
    let id: Int
    let orderType: BranchType
    let day, status, archive: Int
    let dayTimeSlots: [DayTimeSlot]
}

struct DayTimeSlot: Codable {
    let id, startHour, startMinute, closingHour: Int
    let closingMinute, status, archive: Int
}

struct DeliveryZone: Codable {
    let id, minimumDelivery, minimumFreeDelivery: Int
    let lessThanFreeDeliveryCharge, deliveryFee: Double
    //    let firstPartZipCode, secondPartZipCode: String
    let city: CityClass
    let area: AreaStruct
    let status, archive: Int
    let type: CuisineType
}

struct CityClass: Codable {
    let id: Int
    let city: String
    let status, archive: Int
}

struct AreaStruct: Codable {
    let id: Int
    let status, archive: Int
    let area: String
}

struct PaymentMethod: Codable {
    let id: Int
    let charge: Double?
    let minimumAmount, freeAmount: Int
    let status, archive: Int
    let chargeMode: BranchType?
    let branchDetailService: BranchDetailService
    let paymentType: BranchType
    let paymentGateway: PaymentGateway?

    enum CodingKeys: String, CodingKey {
        case id, charge, minimumAmount, freeAmount, status, archive, chargeMode
        case paymentType, paymentGateway
        case branchDetailService = "service"

    }
}

struct BranchDetailService: Codable {
    let id, orderTime, minsBeforeClose, status: Int
    let archive: Int
    let orderType: BranchType
    let hasPreOrdering: Int
    //    let preOrderingNumOfDays: Int
}

struct PaymentGateway: Codable {
    let id: Int
    let name: String
    let companyID: Int?
    let param1, param2, param3: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case companyID = "companyId"
        case param1, param2, param3
    }
}
struct OrderDiscountRule: Codable {
    let id : Int
    let subTotal: Double
    let discount: Double
    let useOnceOnly, status, archive: Int
    let createdDate, expiryDate: String
    let chargeMode, paymentType, orderType: BranchType
}
struct PromoCodeDiscountRule: Codable {
    let id, subTotal: Int
    let discount: Double
    let promoCode: String
    let status, archive: Int
    let chargeMode, paymentType, orderType: BranchType
}
struct Tax: Codable {
    let id: Int
    let taxRule, taxLabel: String
    let rate: Double
    let status, archive: Int
    let chargeMode, orderType: BranchType
}

struct Category: Codable {
    let id: Int
    let name: String
    let description: String
    let position, status, archive: Int
    let products: [Product]
}

struct Product: Codable {
    let id: Int
    var code, name, description: String
    let productPhotoURL: String?
    let promotionCode: String?
    var price: Double
    var totalPrice: Double?
    var specialInstruction: String?
    var quantity: Int?
    let position, status, archive: Int
    let optionGroups: [OptionGroup]

    enum CodingKeys: String, CodingKey {
        case id, code, name, description
        case productPhotoURL = "productPhotoUrl"
        case promotionCode
        case price, totalPrice, specialInstruction, quantity, position, status, archive, optionGroups
    }
    
//    init(dictionary: [String: Any]) {
//        self.id = dictionary["id"] as! Int
//        self.code = dictionary["code"] as! String
//        self.name = dictionary["name"] as! String
//        self.description = dictionary["description"] as! String
//        
//        self.price = dictionary["price"] as! Double
//        self.position = dictionary["position"] as! Int
//        self.status = dictionary["status"] as! Int
//        self.archive = dictionary["archive"] as! Int
//        
//        self.op = dictionary["archive"] as! Int
//        
//        
//        
//    }
}

struct OptionGroup: Codable {
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


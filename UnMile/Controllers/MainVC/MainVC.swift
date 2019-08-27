//
//  MainVC.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/14/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit
import SideMenu

enum DeliveryZoneType {
    static let cityArea = "CITYAREA"
    static let postalCode = "POSTALCODE"
}

class MainVC: BaseViewController {

    var city: CityObject?
    var area: AreaObject?

    @IBOutlet weak var appIcon: UIImageView!
    
    var companyDetails: CompanyDetails!

    lazy var discoverMenu : UIButton = {
        let btn = UIButton(frame: CGRect.zero)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Discover Menu", for: .normal)
        btn.backgroundColor = Color.purple
        return btn
    }()
    var firstLabel: UILabel!
    var cityAreaView: CityAreaView!
    var deliveryZoneType = DeliveryZoneType.cityArea

    override func viewDidLoad() {
        super.viewDidLoad()

        if deliveryZoneType == DeliveryZoneType.cityArea {

            cityAreaView = Bundle.main.loadNibNamed("CityAreaView", owner: nil, options: [:])?.first as? CityAreaView

            view.addSubview(cityAreaView)

            cityAreaView.translatesAutoresizingMaskIntoConstraints = false
            cityAreaView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            cityAreaView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            cityAreaView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            cityAreaView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            cityAreaView.topAnchor.constraint(equalTo: self.appIcon.bottomAnchor).isActive = true

            cityAreaView.cityButton.addTarget(self, action: #selector(loadSearchVC(with:)), for: .touchUpInside)
            cityAreaView.areaButton.addTarget(self, action: #selector(loadSearchVC(with:)), for: .touchUpInside)
            cityAreaView.findRestaurentsButton.addTarget(self, action: #selector(showRestaurantsViewController), for: .touchUpInside)
         
            cityAreaView.findRestaurentsButton.layer.cornerRadius = 7
            
            cityAreaView.autoLocateButton.layer.cornerRadius = 7

        } else if deliveryZoneType == DeliveryZoneType.postalCode {
            let postalCodeView = Bundle.main.loadNibNamed("PostalCodeView", owner: nil, options: [:])?.first as! PostalCodeView                                                                                                                                                                           

            view.addSubview(postalCodeView)

            postalCodeView.translatesAutoresizingMaskIntoConstraints = false
            postalCodeView.widthAnchor.constraint(equalToConstant: 300).isActive = true
            postalCodeView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            postalCodeView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            postalCodeView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            postalCodeView.topAnchor.constraint(equalTo: self.appIcon.bottomAnchor).isActive = true
        } else {
            view.addSubview(discoverMenu)
            discoverMenu.widthAnchor.constraint(equalToConstant: 150).isActive = true
            discoverMenu.heightAnchor.constraint(equalToConstant: 40).isActive = true
            discoverMenu.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            discoverMenu.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 60).isActive = true
            discoverMenu.topAnchor.constraint(equalTo: self.appIcon.bottomAnchor).isActive = true
        }
        slideMenu()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

      
        if let tabItems = tabBarController?.tabBar.items {
        
            let tabItem = tabItems[1]
            tabItem.badgeValue = "0"
            if let cartBag = UserDefaults.standard.object(forKey: "Bag"){
                
                tabItem.badgeValue = "\(cartBag)"
                print(cartBag)
            }
            else{
                
                tabItem.badgeValue = "0"
            }
        }
        
        
       // Getting Saved City and Area Values
   
        if let savedCity = UserDefaults.standard.object(forKey: "SavedCity") as? Data  {
            let decoder = JSONDecoder()
            if let loadedCity = try? decoder.decode(CityObject.self, from: savedCity) {
                guard let cityView = cityAreaView else { fatalError("cityAreaView Not Found") }
                cityView.cityButton.setTitle(loadedCity.name, for: .normal)
                
            }
        }
        
        
        if let savedArea = UserDefaults.standard.object(forKey: "SavedArea") as? Data  {
            let decoder = JSONDecoder()
            if let loadedArea = try? decoder.decode(AreaObject.self, from: savedArea) {
                guard let cityView = cityAreaView else { fatalError("cityAreaView Not Found") }
                cityView.areaButton.setTitle(loadedArea.area, for: .normal)
            }
        }
        
    }
    func slideMenu(){
        // Define the menus
        //let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: test)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "UISideMenuNavigationController") as! UISideMenuNavigationController
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        //let menuRightNavigationController = UISideMenuNavigationController(rootViewController: test)
        // UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
        // of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
        // let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! UISideMenuNavigationController
       // SideMenuManager.default.menuRightNavigationController = menuRightNavigationController
        // (Optional) Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the view controller it displays!
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
        // (Optional) Prevent status bar area from turning black when menu appears:
        SideMenuManager.default.menuFadeStatusBar = false
        
    }
    @IBAction func sideMenuTapped(_ sender: Any) {
        print("Toogle Side Menu")
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    @objc func loadSearchVC(with sender: UIButton) {
        guard let searchVC = Storyboard.main.instantiateViewController(withIdentifier: SearchVC.identifier) as? SearchVC else {
            fatalError("\(SearchVC.identifier) not found")
        }

        searchVC.isFor = SearchFor(rawValue: sender.tag)!
        if sender.tag == 0 {
            searchVC.cityDelegate = self
            searchVC.companyId = companyId
            
            UserDefaults.standard.removeObject(forKey: "SavedArea")
            guard let cityView = cityAreaView else { fatalError("cityAreaView Not Found") }
            cityView.areaButton.setTitle("Select Your Area", for: .normal)
            self.navigationController?.pushViewController(searchVC, animated: true)
            

        } else {
            
            if let savedCity = UserDefaults.standard.object(forKey: "SavedCity") as? Data  {
                let decoder = JSONDecoder()
                if let loadedCity = try? decoder.decode(CityObject.self, from: savedCity) {

                    searchVC.areaDelegate = self
                    searchVC.cityId = loadedCity.id
                    searchVC.companyId = companyId

                    self.navigationController?.pushViewController(searchVC, animated: true)
                }
            }
            
            
            else{
            
            if let aCity = self.city {
                searchVC.areaDelegate = self
                searchVC.cityId = aCity.id
                searchVC.companyId = companyId

                self.navigationController?.pushViewController(searchVC, animated: true)
            } else {
                showAlert(title: "Select city!", message: "Please select city to continue")
            }
        }
            }
    }

    @objc func showRestaurantsViewController() {
        
        if let savedCity = UserDefaults.standard.object(forKey: "SavedCity") as? Data  {
            let decoder = JSONDecoder()
            if let loadedCity = try? decoder.decode(CityObject.self, from: savedCity) {
                print(loadedCity.name)
           
            if let savedArea = UserDefaults.standard.object(forKey: "SavedArea") as? Data {
                let decoder = JSONDecoder()
                if let loadedArea = try? decoder.decode(AreaObject.self, from: savedArea) {
                    guard let restaurantsVC = Storyboard.main.instantiateViewController(withIdentifier: RestaurantsVC.identifier) as? RestaurantsVC else {
                        fatalError("\(RestaurantsVC.identifier) not found")
                    }
                    restaurantsVC.companyDetails = self.companyDetails
                    //saveCompanyObject(Object: companyDetails, key: "SavedCompany")
                    restaurantsVC.city = (loadedCity.name)
                    
                    restaurantsVC.companyId = 52
                    restaurantsVC.area = (loadedArea.area)
                self.navigationController?.pushViewController(restaurantsVC, animated: true)
                }
                }
            else{
                showAlert(title: "Select area!", message: "Please select area to continue")
                }
            }
            
        }
        else{
        
        if self.city == nil {
            showAlert(title: "Select city!", message: "Please select city to continue")
        } else if self.area == nil {
            showAlert(title: "Select area!", message: "Please select area to continue")
        } else {
//            guard let restaurantsVC = Storyboard.main.instantiateViewController(withIdentifier: RestaurantsVC.identifier) as? RestaurantsVC else {
//                fatalError("\(RestaurantsVC.identifier) not found")
//            }
//            restaurantsVC.companyDetails = self.companyDetails
//            restaurantsVC.city = (self.city?.name)!
//            restaurantsVC.area = (self.area?.area)!
//            restaurantsVC.companyId = self.companyDetails.id
//            self.navigationController?.pushViewController(restaurantsVC, animated: true)
            performSegue(withIdentifier: "MainVC2RestaurentsVC", sender: self)
        }
    
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "MainVC2RestaurentsVC"){
            
             let vc = segue.destination as? RestaurantsVC
            vc!.companyDetails = self.companyDetails
            vc!.city = (self.city?.name)!
            vc!.area = (self.area?.area)!
            vc!.companyId = self.companyDetails.id
        }
    }
}

extension MainVC: SearchVCCityDelegate, SearchVCAreaDelegate {
    func setCity(with city: CityObject) {
        self.city = city
        self.area = nil
       
        guard let cityView = cityAreaView else { fatalError("cityAreaView Not Found") }
        cityView.cityButton.setTitle(city.name, for: .normal)
        cityView.areaButton.setTitle("Select Your Area", for: .normal)

    }

    func setArea(with area: AreaObject) {
        self.area = area
        guard let cityView = cityAreaView else { fatalError("cityAreaView Not Found") }
        cityView.areaButton.setTitle(area.area, for: .normal)
        //UserDefaults.standard.set(area, forKey: "area")
    }
}

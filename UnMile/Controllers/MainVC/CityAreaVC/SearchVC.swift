//
//  SearchVC.swift
//  UnMile
//
//  Created by Adnan Asghar on 1/17/19.
//  Copyright © 2019 Adnan Asghar. All rights reserved.
//

import UIKit

enum SearchFor: Int {
    case city = 0,
    area
}

protocol SearchVCCityDelegate {
    func setCity(with city: CityObject)
}

protocol SearchVCAreaDelegate {
    func setArea(with area: AreaObject)
}

class SearchVC: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var cities = [CityObject]()
    var filteredCities = [CityObject]()

    var areas = [AreaObject]()
    var filteredAreas = [AreaObject]()

    var searchBarIsActive = false
    var cityDelegate: SearchVCCityDelegate?
    var areaDelegate: SearchVCAreaDelegate?

    var isFor = SearchFor.city
    var companyId: Int = 0
    var cityId: Int = 0
    var addressSelection = false
    override func viewDidLoad() {
        super.viewDidLoad()
        startActivityIndicator()
        showNavigationBar()
        setupTableView()
        setupSearchbar()

        if self.isFor == .city {
            getCities()

        } else if self.isFor == .area {
            getAreas()
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    func setupSearchbar() {
        searchBar.delegate = self

        switch self.isFor {
        case .city:
            self.title = "Search City"
        case .area:
            self.title = "Search Area"
        }
    }

    // MARK: - API Calls
    func getCities() {

        let params: [String : Any] = ["countryID":"7",
                      "companyID": self.companyId]
        
        NetworkManager.getDetails(path: Path.companyCityUrl+"/getAll/app", params: params, success: { (json, isError) in

            do {
                let jsonData =  try json.rawData()
                self.cities = try JSONDecoder().decode(CitiesResponse.self, from: jsonData)
                self.tableView.reloadData()
                self.stopActivityIndicator()
                print(self.cities)

            } catch let myJSONError {
                print(myJSONError)
                self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
            }

        }) { (error) in
            //self.dismissHUD()
            self.stopActivityIndicator()
            self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
        }
    }

    func getAreas() {

        let params: [String : Any] = ["countryID":"7",
                      "companyID": self.companyId,
                      "cityID": self.cityId]
        
        let areaUrl = Path.companyCityUrl + "/city/areas"
        NetworkManager.getDetails(path: areaUrl , params: params, success: { (json, isError) in

            do {
                let jsonData =  try json.rawData()
                let anArray = try JSONDecoder().decode(AreaResponse.self, from: jsonData)
                self.areas = anArray.filter({
                    $0.status == 1
                })
                self.tableView.reloadData()
                self.stopActivityIndicator()
                print(self.cities)

            } catch let myJSONError {
                print(myJSONError)
                self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
            }

        }) { (error) in
            //self.dismissHUD()
            self.stopActivityIndicator()
            self.showAlert(title: Strings.error, message: Strings.somethingWentWrong)
        }
    }

}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if self.isFor == .city {
            if searchBarIsActive {
                return filteredCities.count
            } else {
                return cities.count
            }
        } else {
            if searchBarIsActive {
                return filteredAreas.count
            } else {
                return areas.count
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchCell.identifier, for: indexPath) as? SearchCell else { fatalError("\(SearchCell.identifier) not found") }

        switch self.isFor {
        case .city:
            if searchBarIsActive {
                cell.titleLabel?.text = filteredCities[indexPath.row].name
            } else {
                cell.titleLabel?.text = cities[indexPath.row].name
            }
        case .area:
            if searchBarIsActive {
                cell.titleLabel?.text = filteredAreas[indexPath.row].area
            } else {
                cell.titleLabel?.text = areas[indexPath.row].area
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch self.isFor {
        case .city:
            if searchBarIsActive {
                let city = filteredCities[indexPath.row]
                cityDelegate?.setCity(with: city)
                
                if(addressSelection == true)
                {
                     // Saving address selection
                    saveCityObject(Object: city, key: "cityAddress")
                }
                else{
                    //Saving User City Selection
                    saveCityObject(Object: city, key: "SavedCity")
                }
                dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            } else {
                let city = cities[indexPath.row]
                cityDelegate?.setCity(with: city)
                
                if(addressSelection == true)
                {
                     // Saving address selection
                    saveCityObject(Object: city, key: "cityAddress")
                }
                else{
                    //Saving User City Selection
                    saveCityObject(Object: city, key: "SavedCity")
                }
                dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }

        case .area:
            if searchBarIsActive {
                let area = filteredAreas[indexPath.row]
                areaDelegate?.setArea(with: area)
                if(addressSelection == true)
                {
                    // Saving address selection
                    saveAreaObject(Object: area, key: "cityAreaAddress")
                }
                else{
                    //Saving User Area Selection
                    saveAreaObject(Object: area, key: "SavedArea")
                }
                
                dismiss(animated: true, completion: nil)
               self.navigationController?.popViewController(animated: true)
            } else {
                let area = areas[indexPath.row]
                areaDelegate?.setArea(with: area)
                
                if(addressSelection == true)
                {
                     // Saving address selection
                    saveAreaObject(Object: area, key: "cityAreaAddress")
                }
                else{
                    //Saving User Area Selection
                    saveAreaObject(Object: area, key: "SavedArea")
                }
                 dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarIsActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarIsActive = false
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarIsActive = false
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarIsActive = false
        searchBar.endEditing(true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if self.isFor == .city {
            filteredCities = cities.filter({
                $0.name.localizedCaseInsensitiveContains(searchText)
            })

            if filteredCities.count == 0 && searchText.count == 0 {
                filteredCities = cities
            }
        } else {
            filteredAreas = areas.filter({
                $0.area.localizedCaseInsensitiveContains(searchText)
            })

            if filteredAreas.count == 0 && searchText.count == 0 {
                filteredAreas = areas
            }
        }
        
        tableView.reloadData()
    }
}


typealias CitiesResponse = [CityObject]

struct CityObject: Codable{
    let id: Int
    let name: String
}

typealias AreaResponse = [AreaObject]

struct AreaObject: Codable {
    let id: Int
    let area: String
    let status, archive: Int
}

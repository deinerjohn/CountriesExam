//
//  ViewController.swift
//  CountriesExam
//
//  Created by Blue Solution Networks on 3/18/21.
//

import UIKit

class ViewController: UITableViewController {
    
    var apiService = APIService()
    let cellID = "cellID"
    
    var countriesData = [Countries]()
    var resultTable: SearchResultController!
    
    lazy var searchController: UISearchController = {
        resultTable = SearchResultController()
        resultTable.tableView.delegate = self
        let controller = UISearchController(searchResultsController: resultTable)
        controller.loadViewIfNeeded()
//        controller.obscuresBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.delegate = self
        controller.searchResultsUpdater = self
        controller.delegate = self
        controller.view.backgroundColor = .white
//        controller.automaticallyShowsSearchResultsController = false
        return controller
    }()
    
    var searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search for a country"
        label.font = .boldSystemFont(ofSize: 15)
        label.textColor = .gray
        label.isHidden = true
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = self.navigationController?.navigationBar else {return}
        navBar.topItem?.hidesSearchBarWhenScrolling = false
        navBar.topItem?.searchController = self.searchController
        
        apiService.getCountries { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.countriesData = data
            case .failure(let err):
            print(err)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        
//        if (self.searchController.isActive) {
//            self.searchController.dismiss(animated: false) {
//                self.isSearching = false
//                self.searchController.searchBar.text?.removeAll()
//                self.filterData.removeAll()
//                self.tableView.reloadData()
//            }
//        }else {
//
//        }
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(CountriesCell.self, forCellReuseIdentifier: cellID)
        
        view.backgroundColor = .white
//        searchController.view.addSubview(searchLabel)
//        NSLayoutConstraint.activate([
//            searchLabel.centerXAnchor.constraint(equalTo: searchController.view.centerXAnchor, constant: 0),
//            searchLabel.topAnchor.constraint(equalTo: searchController.view.topAnchor, constant: 20)
//        ])
        
        
        self.definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CountriesCell
        
            let countries = self.countriesData[indexPath.row]
            
            DispatchQueue.main.async {
                cell.setCellValues(countries)
            }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let countries = self.countriesData[indexPath.row]

            if let cell = tableView.cellForRow(at: indexPath) as? CountriesCell {
                guard let image = cell.countryFlag.image else {return}
                self.navigateToDetailScreen(countryName: countries.name, capital: countries.capital, alphaCode: countries.alpha2Code + "," + countries.alpha3Code, population: countries.population, countryFlag: image)
            }
        }else {
            let filteredData = self.resultTable.filteredData[indexPath.row]

            if let cell = tableView.cellForRow(at: indexPath) as? CountriesCell {
                guard let image = cell.countryFlag.image else {return}
                self.navigateToDetailScreen(countryName: filteredData.name, capital: filteredData.capital, alphaCode: filteredData.alpha2Code + "," + filteredData.alpha3Code, population: filteredData.population, countryFlag: image)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func navigateToDetailScreen(countryName: String, capital: String, alphaCode: String, population: Int, countryFlag: UIImage) {
        let view = CountryDetailView()
        view.modalPresentationStyle = .fullScreen
        view.countryName.text = countryName
        view.capitalVal = capital
        view.alphaCodeVal = alphaCode
        view.populationVal = population
        view.countryFlag.image = countryFlag
        guard let navBar = self.navigationController else {return}
        navBar.pushViewController(view, animated: true)
    }
    
}

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        let searchResults = countriesData
        
        let filteredResults = searchResults.filter { (countries) -> Bool in
            countries.name.lowercased().contains(searchText.lowercased())
        }
        
        
        if let resultsController = searchController.searchResultsController as? SearchResultController {
            resultsController.filteredData = filteredResults
            resultsController.resultsLabel.isHidden = true
            resultsController.tableView.isHidden = false
            resultsController.tableView.reloadData()
            

            
            if (resultsController.filteredData.count == 0) {
                resultsController.resultsLabel.isHidden = false
                resultsController.tableView.isHidden = true
            }
            
        }
        
//        let searchText = searchController.searchBar.text!
//        if !searchText.isEmpty {
//
//            self.isSearching = true
//            filterData.removeAll()
//
//            for country in countriesData {
//                if (country.name!.lowercased().contains(searchText.lowercased()) || country.alpha2Code!.elementsEqual(searchText) || country.alpha3Code!.elementsEqual(searchText)) {
//                    filterData.removeAll()
//                    filterData.append(country)
//                }else {
//                }
////                 if (country.name!.lowercased().contains(searchText.lowercased())) {
////                    filterData.removeAll()
////                    filterData.append(country)
////                }else if (searchText.contains(country.alpha2Code) || searchText.contains(country.alpha3Code)) {
////                    filterData.removeAll()
////                    filterData.append(country)
////                }
//
//            }
//        }else {
//            self.isSearching = false
//            self.filterData.removeAll()
//            self.filterData = self.countriesData
//        }
//
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
//        let searchText = searchController.searchBar.text!
//        if !searchText.isEmpty {
//
//            self.isSearching = true
//            filterData.removeAll()
//
//            for country in countriesData {
////                if (country.name!.lowercased().contains(searchText.lowercased()) || country.alpha2Code!.contains(searchText) || country.alpha3Code!.contains(searchText)) {
////                    filterData.append(country)
////                }
//
//                if (country.alpha2Code!.contains(searchText) || country.alpha3Code!.contains(searchText)) {
//                    filterData.append(country)
//                }
//
//            }
//        }else {
//            self.isSearching = false
//            self.filterData.removeAll()
//            self.filterData = self.countriesData
//        }
//
//        self.tableView.reloadData()
    }
    
}


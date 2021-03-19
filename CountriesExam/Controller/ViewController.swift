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
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.delegate = self
        controller.searchResultsUpdater = self
        controller.delegate = self
        controller.view.backgroundColor = .white
        return controller
    }()
    
    var upperLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Search for countries"
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .gray
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = self.navigationController?.navigationBar else {return}
        navBar.topItem?.hidesSearchBarWhenScrolling = false
        navBar.topItem?.searchController = self.searchController
        
        if (self.countriesData.isEmpty) {
            apiService.getCountries {(result) in
                switch result {
                case .success(let data):
                    self.countriesData = data
                case .failure(let err):
                print(err)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
        super.viewWillAppear(animated)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        tableView.register(CountriesCell.self, forCellReuseIdentifier: cellID)
        searchController.view.insertSubview(upperLabel, at: 1)
        NSLayoutConstraint.activate([
            upperLabel.topAnchor.constraint(equalTo: searchController.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            upperLabel.centerXAnchor.constraint(equalTo: searchController.view.centerXAnchor, constant: 0)
        ])
        
        self.definesPresentationContext = true
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countriesData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CountriesCell
        
        let countries = self.countriesData[indexPath.row]
        cell.setCellValues(countries)
            
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
            countries.name.lowercased().contains(searchText.lowercased()) ||
                countries.alpha2Code.elementsEqual(searchText) ||
                countries.alpha3Code.elementsEqual(searchText)
        }
        
        if let resultsController = searchController.searchResultsController as? SearchResultController {
            resultsController.filteredData = filteredResults
            resultsController.resultsLabel.isHidden = true
            
            if (resultsController.filteredData.isEmpty && filteredResults.isEmpty) {
                resultsController.resultsLabel.isHidden = false
                resultsController.resultsLabel.text = "No results found for \(searchText)"
            }
            
            resultsController.tableView.reloadData()
        }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.tableView.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tableView.isHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            self.upperLabel.isHidden = false
        }else {
            self.upperLabel.isHidden = true
        }
    }
    
}


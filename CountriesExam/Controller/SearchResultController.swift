//
//  SearchResultController.swift
//  CountriesExam
//
//  Created by Blue Solution Networks on 3/18/21.
//

import Foundation
import UIKit

class SearchResultController: UIViewController, UITableViewDataSource {
    
    let cellID = "cellID"
    var filteredData = [Countries]()
    
    var resultsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 25)
        label.textColor = .gray
        label.isHidden = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(CountriesCell.self, forCellReuseIdentifier: cellID)
        view.dataSource = self
        view.backgroundColor = .white
        view.isMultipleTouchEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
        
        tableView.addSubview(resultsLabel)
        NSLayoutConstraint.activate([
            resultsLabel.topAnchor.constraint(equalTo: tableView.safeAreaLayoutGuide.topAnchor, constant: 15),
            resultsLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor, constant: 0)
        ])
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CountriesCell
        
        let filteredData = self.filteredData[indexPath.row]
        
        DispatchQueue.main.async {
            cell.data = filteredData
        }
        
        return cell
    }
    
}

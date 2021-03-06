//
//  CountryDetailView.swift
//  CountriesExam
//
//  Created by Blue Solution Networks on 3/18/21.
//

import Foundation
import UIKit
import SVGKit
import WebKit

class CountryDetailView: UIViewController {
    
    var svgURL: String!
    
    var countryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 25)
        label.adjustsFontSizeToFitWidth = true
        label.contentMode = .center
        return label
    }()
    
//    var countryFlag: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.borderWidth = 1
//        imageView.layer.borderColor = UIColor.gray.cgColor
//        return imageView
//    }()
    
   lazy var countryFlag: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        let wv = WKWebView(frame: .zero, configuration: configuration)
        let url = URL(string: svgURL)!
        let request = URLRequest(url: url)
        wv.load(request)
        wv.translatesAutoresizingMaskIntoConstraints = false
        wv.clipsToBounds = true
        wv.scrollView.isScrollEnabled = false
        wv.isUserInteractionEnabled = false
        return wv
    }()
    
    var capitalVal: String!
    var alphaCodeVal: String!
    var populationVal: Int!
    
    lazy var countryCapital: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "Capital:" + capitalVal
        label.font = .boldSystemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countryAlpha: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "AlphaCode: " + alphaCodeVal
        label.font = .boldSystemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var countryPopulation: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        let result = formatter.string(from: NSNumber(value: populationVal))
        label.text = "Population: " + result!
        label.font = .boldSystemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(countryFlag)
        NSLayoutConstraint.activate([
            countryFlag.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countryFlag.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            countryFlag.heightAnchor.constraint(equalToConstant: view.bounds.height / 3),
            countryFlag.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            countryFlag.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30)
        ])
        
        view.addSubview(countryName)
        NSLayoutConstraint.activate([
            countryName.bottomAnchor.constraint(equalTo: countryFlag.topAnchor, constant: -10),
            countryName.leftAnchor.constraint(equalTo: countryFlag.leftAnchor, constant: 0),
            countryName.rightAnchor.constraint(equalTo: countryFlag.rightAnchor, constant: 0)
        ])
        
        view.addSubview(countryCapital)
        NSLayoutConstraint.activate([
            countryCapital.topAnchor.constraint(equalTo: countryFlag.bottomAnchor, constant: 10),
            countryCapital.leftAnchor.constraint(equalTo: countryFlag.leftAnchor, constant: 0),
            countryCapital.rightAnchor.constraint(equalTo: countryName.rightAnchor, constant: 0)
        ])
        
        view.addSubview(countryAlpha)
        NSLayoutConstraint.activate([
            countryAlpha.topAnchor.constraint(equalTo: countryCapital.bottomAnchor, constant: 10),
            countryAlpha.leftAnchor.constraint(equalTo: countryFlag.leftAnchor, constant: 0),
            countryAlpha.rightAnchor.constraint(equalTo: countryName.rightAnchor, constant: 0)
        ])
        
        view.addSubview(countryPopulation)
        NSLayoutConstraint.activate([
            countryPopulation.topAnchor.constraint(equalTo: countryAlpha.bottomAnchor, constant: 10),
            countryPopulation.leftAnchor.constraint(equalTo: countryFlag.leftAnchor, constant: 0),
            countryPopulation.rightAnchor.constraint(equalTo: countryName.rightAnchor, constant: 0)
        ])
        
    }
    
}

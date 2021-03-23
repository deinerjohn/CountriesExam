//
//  CountriesCell.swift
//  CountriesExam
//
//  Created by Blue Solution Networks on 3/18/21.
//

import Foundation
import UIKit
import SVGKit
import SDWebImage
import SDWebImageSVGKitPlugin

class CountriesCell: UITableViewCell {
    
    var data: Countries? {
        didSet {
            self.countryName.text = data?.name
            self.countryCIOC.text = data?.cioc
            self.setupImageFlag()
        }
    }
    
    func setupImageFlag() {
        if let profileImageUrl = data?.flag {
//            countryFlag.downloadSVG(urlString: profileImageUrl)
//
            let svgCoder = SDImageSVGKCoder.shared
            SDImageCodersManager.shared.addCoder(svgCoder)

            let url = URL(string: profileImageUrl)!

            let svgImageSize = CGSize(width: 50, height: 50)
            countryFlag.sd_setImage(with: url, placeholderImage: UIImage(named: "noImage"), options: [], context: [.imageThumbnailPixelSize : svgImageSize])
            
        }
        
    }
    
    let chevronAcce: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "chevronRight")?.withRenderingMode(.alwaysTemplate)
        view.tintColor = .gray
        return view
    }()
    
    var countryFlag: SVGKFastImageView = {
        let imageView = SVGKFastImageView.init(svgkImage: nil)!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var imageUrlString: String?
    let imageCache = NSCache<NSString, UIImage>()
    
    let countryName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SAMPLE"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 2
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let countryCIOC: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "AFG"
        label.textColor = .black
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        addSubview(chevronAcce)
        NSLayoutConstraint.activate([
            chevronAcce.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            chevronAcce.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            chevronAcce.widthAnchor.constraint(equalToConstant: 15),
            chevronAcce.heightAnchor.constraint(equalToConstant: 15)
        ])
        
        addSubview(countryFlag)
        NSLayoutConstraint.activate([
            countryFlag.widthAnchor.constraint(equalToConstant: bounds.width / 4),
            countryFlag.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            countryFlag.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            countryFlag.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
        addSubview(countryName)
        NSLayoutConstraint.activate([
            countryName.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            countryName.leftAnchor.constraint(equalTo: countryFlag.rightAnchor, constant: 20),
            countryName.rightAnchor.constraint(equalTo: chevronAcce.leftAnchor, constant: -10),
        ])
        addSubview(countryCIOC)
        NSLayoutConstraint.activate([
            countryCIOC.topAnchor.constraint(equalTo: countryName.bottomAnchor, constant: 5),
            countryCIOC.leftAnchor.constraint(equalTo: countryFlag.rightAnchor, constant: 20),
            countryCIOC.rightAnchor.constraint(equalTo: chevronAcce.leftAnchor, constant: -10),
            countryCIOC.bottomAnchor.constraint(equalTo: countryFlag.bottomAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setCellValues(_ countries: Countries) {
//        self.updateView(country: countries.name, cioc: countries.cioc, flag: countries.flag)
//    }
//
//    func updateView(country: String?, cioc: String?, flag: String?) {
//        self.countryName.text = country
//        self.countryCIOC.text = cioc
//        guard let flag = flag else {return}
//
//        countryFlag.downloadSVG(urlString: flag)
//
//    }
    
}

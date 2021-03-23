//
//  CustomSVGView.swift
//  CountriesExam
//
//  Created by Blue Solution Networks on 3/23/21.
//

import Foundation
import UIKit
import SVGKit

let imageCache = NSCache<NSString, UIImage>()

class CustomSVGView: UIImageView {
    
    var imageUrlString: String?
    
    func downloadSVG(urlString: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        imageUrlString = urlString
        guard let url = URL(string: urlString) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, responses, error) in
            if error != nil {
                print("eto ung error", error ?? "")
                return
            }
            
//            guard let mimeType = responses?.mimeType, mimeType.hasPrefix("image") else {return}
            DispatchQueue.main.async {
                guard let data = data else {return}
                
                print("eto data sa image",data)
                guard let receivedImage: SVGKImage = SVGKImage(data: data) else {return}
//                let image = receivedImage.uiImage
//                self.image = image
                guard let imageToCache = receivedImage.uiImage else { return }
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache, forKey: urlString as NSString)
            }
            
        }).resume()
    }
    
}

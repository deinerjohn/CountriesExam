//
//  APIService.swift
//  CountriesExam
//
//  Created by Blue Solution Networks on 3/18/21.
//

import Foundation

class APIService {
    
    private var task: URLSessionTask?
    
    func getCountries(completion: @escaping (Result<[Countries], Error>) -> Void) {
        
        let countriesAPI = "https://restcountries.eu/rest/v2/all"
        guard let url = URL(string: countriesAPI) else {return}
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Handle Error
            if let error = error {
                completion(.failure(error))
                print("DataTask error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                // Handle Empty Response
                print("Empty Response")
                return
            }
            print("Response status code for firstcell: \(response.statusCode)")
            
            guard let data = data else {
                print("Empty Data")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Countries].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            } catch let error {
                completion(.failure(error))
            }
            
        }
        task?.resume()
    }
    
}

//
//  APIManager.swift
//  weather
//
//  Created by Gareth Ng on 2023/11/27.
//

import Foundation

struct ResponseData: Codable {
    // Define your data structure here
    var poem: String?
    var image_url: String?
}


struct APIManager {
    
    func getAIWeather(from city: String, withWeather weather: String, andTemperature temperature: String) async -> [String: String]? {
        let queryURLString = "https://beqi0stida.execute-api.us-east-1.amazonaws.com/beta/get_weather"
        guard let queryURL = URL(string: queryURLString) else { return nil}
        
        var request = URLRequest(url: queryURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 60
        
        guard var components = URLComponents(url: queryURL, resolvingAgainstBaseURL: false) else {return nil}
        components.queryItems = [
            URLQueryItem.init(name: "city", value: city),
            URLQueryItem.init(name: "weather", value: weather),
            URLQueryItem.init(name: "temperature", value: temperature)
        ]
        request.url = components.url
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let (data, response) = try? await URLSession.shared.data(for: request) else {return nil}
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data) as? [String: String] {
                return json
            }
        }catch let error{
            print("Failed to convert data to JSON: \(error)")
        }
        
        return nil
    }
}

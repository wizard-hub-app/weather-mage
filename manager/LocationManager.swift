//
//  LocationManager.swift
//  weather
//
//  Created by Gareth Ng on 2023/11/12.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    var currentLocation: CLLocation?
    var cityName: String? = nil
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        currentLocation = location
        // 获取城市名称
        getCityName(from: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location: \(error.localizedDescription)")
    }

    private func getCityName(from location: CLLocation) {
        Task {
            do{
                let placeMarks = try await CLGeocoder().reverseGeocodeLocation(location)
                
                if let placeMark = placeMarks.first, let city = placeMark.locality {
                    DispatchQueue.main.async { [unowned self] in
                        self.cityName = city
                    }
                }
            }catch{
                print(error)
            }
            
        }
             
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard error == nil else {
                print("Geocoding error: \(error!.localizedDescription)")
                return
            }
            if let placemark = placemarks?.first, let city = placemark.locality {
                print("Current city: \(city)")
                let userInfo = ["city": city]
                NotificationCenter.default.post(name: .purchaseDidFinish, object: nil, userInfo: userInfo)
                self.cityName = city
                // 这里你可以将城市名称保存或使用
            }
        }
    }
}

import Foundation

extension Notification.Name {
    static let purchaseDidFinish = Notification.Name("purchaseDidFinish")
    static let downModelDidSuccessfully = Notification.Name("downModelDidSuccessfully")
    static let downModelDidUnsuccessfully = Notification.Name("downModelDidSuccessfully")
}

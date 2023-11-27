//
//  WeatherArtView.swift
//  weather
//
//  Created by Gareth Ng on 2023/11/12.
//

import SwiftUI
import WeatherKit
import CoreLocation
import SDWebImageSwiftUI

struct WeatherArtView: View {
    @State private var weatherImageURL: String?
    @State private var weatherPoem: String? = "Gentle sun, warm rays alight,\nUpon the meadow, bright and light.\nTrees in whispers, skies so clear,\nIn this moment, peace draws near."
    @State private var cityName: String?
    @State private var weather: CurrentWeather?
    @State private var temperature: Int?
    @State private var weatherStatus: String?
    
    private var locatoinManager = LocationManager()
    var body: some View {
            NavigationView {
                ScrollView {
                    VStack {
                        weatherImageSection
                        weatherInfoSection
                        poemSection
                    }
                    .padding()
                }
                .navigationTitle(cityName ?? "")
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: {
                    locatoinManager.manager.startUpdatingLocation()
                })
            }
            .onReceive(NotificationCenter.default.publisher(for: .purchaseDidFinish), perform: { notification in
                if let userInfo = notification.userInfo as? [String: Any] {
                    if let cityName = userInfo["city"] as? String, let location = userInfo["location"] as? CLLocation {
                        self.cityName = cityName
                        Task{
                            self.weather = await WeatherManager.sharedd.weather(for: location)
                            self.temperature = Int(self.weather?.temperature.value ?? 0)
                            self.weatherStatus = self.weather?.condition.rawValue ?? ""
                            if let temperature = self.temperature, let weatherStatus = self.weatherStatus {
                                let response = await APIManager().getAIWeather(from: cityName, withWeather: weatherStatus, andTemperature: "\(temperature)")
                                self.weatherPoem = response?["poem"]
                                self.weatherImageURL = response?["image_url"]
                            }
                            print(("\(weather?.temperature.value ?? 0)" ))
                        }
                        
                        
                        locatoinManager.manager.stopUpdatingLocation()
                    }
                }
            })
        }
    
    var weatherInfoSection: some View {
        HStack {
            Text("温度：\(temperature ?? 0)°C")
            Spacer()
            Text(weatherStatus ?? "")
            Spacer()
        }
        .padding(.vertical)
    }
    
    private var weatherImageSection: some View {
        Group {
            WebImage(url: URL(string: weatherImageURL ?? "")) 
                // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                .onSuccess { image, data, cacheType in
                    
                    // Success
                    // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                }.resizable()
                .indicator(.activity) // Activity Indicator
                .transition(.fade(duration: 0.5)) // Fade Transition with duration
                .scaledToFit()
                .frame(width: 300, height: 300, alignment: .center)
        }

    }

    private var poemSection: some View {
        Text(weatherPoem ?? "")
            .font(.custom("", size: 18)) // 替换为你选择的字体
            .italic() // 如果适用
            .lineSpacing(4) // 调整行间距
            .padding()
            .frame(maxWidth: .infinity)
//            .background(backgroundColorForPoem) // 使用函数来动态确定背景色
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            .shadow(radius: 5)
            .transition(.opacity)
    }

    private func fetchWeatherArt() {
        // Fetch the weather image and poem here
    }
    
    private func backgroundColorForPoem() -> Color {
        // 根据天气或其他条件动态选择颜色
        return Color.white.opacity(0.8) // 举例
    }

}

// Define your custom colors in an extension
extension Color {
    static let Background = Color("Background")
    static let Text = Color("Text")
}

struct WeatherArtView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherArtView()
    }
}


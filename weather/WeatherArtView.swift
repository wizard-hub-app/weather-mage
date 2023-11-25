//
//  WeatherArtView.swift
//  weather
//
//  Created by Gareth Ng on 2023/11/12.
//

import SwiftUI
import WeatherKit

struct WeatherArtView: View {
    @State private var weatherImage: UIImage?
    @State private var weatherPoem: String = "Gentle sun, warm rays alight,\nUpon the meadow, bright and light.\nTrees in whispers, skies so clear,\nIn this moment, peace draws near."
    @State private var cityName: String = "Weather Art"
    
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
                .navigationTitle(cityName)
                .navigationBarTitleDisplayMode(.inline)
                .onAppear(perform: {
                    locatoinManager.manager.startUpdatingLocation()
                })
            }
            .onReceive(NotificationCenter.default.publisher(for: .purchaseDidFinish), perform: { notification in
                if let userInfo = notification.userInfo as? [String: String] {
                    if let cityName = userInfo["city"] {
                        self.cityName = cityName
                        locatoinManager.manager.stopUpdatingLocation()
                    }
                }
            })
        }
    
    var weatherInfoSection: some View {
        HStack {
            Text("温度：24°C")
            Spacer()
            Text("湿度: 60%")
            Spacer()
            Text("风速: 5 km/h")
        }
        .padding(.vertical)
    }
    
    private var weatherImageSection: some View {
        Group {
            if let image = weatherImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 300)
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2))
            } else {
                // Placeholder for image loading state
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(Text("Loading image..."))
            }
        }

    }

    private var poemSection: some View {
        Text(weatherPoem)
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
            .animation(.easeInOut(duration: 1.0))
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


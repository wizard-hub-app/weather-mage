//
//  ContentView.swift
//  weather
//
//  Created by Gareth Ng on 2023/11/12.
//
import SwiftUI
import CoreLocation

import SwiftUI



struct MainTabView: View {
    var body: some View {
        TabView {
            WeatherArtView()
                .tabItem {
                    Label("Weather Art", systemImage: "cloud.sun")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}


struct SettingsView: View {
    var body: some View {
        Text("Settings")
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}

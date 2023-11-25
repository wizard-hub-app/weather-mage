//
//  WeatherManager.swift
//  weather
//
//  Created by Gareth Ng on 2023/11/25.
//

import Foundation
import WeatherKit

class WeatherManager{
    static let sharedd = WeatherManager()
    
    private let weatherService = WeatherService.shared

    @Published
    public var alerts: [WeatherAlert]?

    @Published
    public var current: CurrentWeather?

    @Published
    public var daily: Forecast<DayWeather>?

    @Published
    public var hourly: Forecast<HourWeather>?

    @Published
    public var minute: Forecast<MinuteWeather>?

    @Published
    public var availability: WeatherAvailability?

    public init() {}

    public func weather(for location: CLLocation) {
        self.alerts = nil
        self.current = nil
        self.daily = nil
        self.hourly = nil
        self.minute = nil
        self.availability = nil

        Task {
            do {
                let weather = try await weatherService.weather(
                    for: location,
                    including: .alerts, .current, .daily, .hourly, .minute, .availability
                )

                DispatchQueue.main.async { [unowned self] in
                    self.alerts = weather.0
                    self.current = weather.1
                    self.daily = weather.2
                    self.hourly = weather.3
                    self.minute = weather.4
                    self.availability = weather.5
                }
            } catch {
                print(error)
            }
        }
    }
}

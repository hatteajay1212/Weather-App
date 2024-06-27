//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Ajay Hatte on 25/06/24.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var viewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

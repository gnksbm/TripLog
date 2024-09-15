//
//  AppDelegate.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import UIKit

final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        registerDependencies()
        return true
    }
    
    func registerDependencies() {
        DIContainer.register(DefaultNetworkService(), type: NetworkService.self)
        DIContainer.register(DefaultTouristRepository(), type: TouristRepository.self)
    }
}

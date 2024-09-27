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
        setAppearance()
        return true
    }
    
    func registerDependencies() {
        DIContainer.register(DefaultNetworkService(), type: NetworkService.self)
        DIContainer.register(
            DefaultTouristRepository(),
            type: TouristRepository.self
        )
        DIContainer.register(
            DefaultLocationService(),
            type: LocationService.self
        )
        DIContainer.register(
            DefaultScheduleRepository(),
            type: ScheduleRepository.self
        )
        DIContainer.register(
            MockRecordRepository(),
            type: RecordRepository.self
        )
        DIContainer.register(
            DefaultImageRepository(),
            type: ImageRepository.self
        )
        DIContainer.register(
            DefaultRealmStorage(),
            type: RealmStorage.self
        )
    }
    
    func setAppearance() {
        let image = UIImage(systemName: "chevron.backward.circle.fill")
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        UINavigationBar.appearance().backItem?.backButtonTitle = ""
//        UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension UINavigationController {
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationBar.topItem?.backButtonDisplayMode = .minimal
//        navigationBar.topItem?.backButtonTitle = ""
    }
}

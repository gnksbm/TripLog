//
//  TripLogApp.swift
//  TripLog
//
//  Created by gnksbm on 9/10/24.
//

import SwiftUI

@main
struct TripLogApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var delegate
    
    var body: some Scene {
        WindowGroup {
            MainTab()
        }
    }
}

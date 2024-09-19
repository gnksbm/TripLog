//
//  LocationService.swift
//  TripLog
//
//  Created by gnksbm on 9/19/24.
//

import CoreLocation
import Foundation

protocol LocationService {
    func requestAuthorization() async -> CLAuthorizationStatus
    func fetchCurrentLocation() async throws -> CLLocation
}

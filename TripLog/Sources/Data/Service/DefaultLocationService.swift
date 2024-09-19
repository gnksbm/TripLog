//
//  DefaultLocationService.swift
//  TripLog
//
//  Created by gnksbm on 9/19/24.
//

import Combine
import CoreLocation
import Foundation

final class DefaultLocationService: NSObject, LocationService {
    private lazy var locationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
    
    private let location = PassthroughSubject<CLLocation, Error>()
    private let authorizationStatus =
    PassthroughSubject<CLAuthorizationStatus, Never>()
    private var cancelBag = Set<AnyCancellable>()
    
    func requestAuthorization() async -> CLAuthorizationStatus {
        locationManager.requestWhenInUseAuthorization()
        return await withCheckedContinuation { continuation in
            authorizationStatus
                .sink { status in
                    continuation.resume(returning: status)
                }
                .store(in: &cancelBag)
        }
    }
    
    func fetchCurrentLocation() async throws -> CLLocation {
        locationManager.requestLocation()
        return try await withCheckedThrowingContinuation { continuation in
            location
                .timeout(10, scheduler: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        continuation.resume(
                            throwing: LocationError.streamFinished
                        )
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                } receiveValue: { coordinate in
                    continuation.resume(returning: coordinate)
                }
                .store(in: &cancelBag)
        }
    }
    
    enum LocationError: Error {
        case missingLocation, streamFinished
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let currentLocation = locations.first else {
            location.send(completion: .failure(LocationError.missingLocation))
            return
        }
        location.send(currentLocation)
    }
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        authorizationStatus.send(manager.authorizationStatus)
    }
}

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
    private lazy var locationManager = CLLocationManager()
    private let location = PassthroughSubject<CLLocation, Error>()
    private let authorizationStatus =
    PassthroughSubject<CLAuthorizationStatus, Error>()
    private var cancelBag = Set<AnyCancellable>()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestAuthorization() async throws -> CLAuthorizationStatus {
        return try await withCheckedThrowingContinuation { continuation in
            authorizationStatus
                .prefix(1)
                .timeout(10, scheduler: DispatchQueue.main)
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            break
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    },
                    receiveValue: { status in
                        continuation.resume(returning: status)
                    }
                )
                .store(in: &cancelBag)
            switch locationManager.authorizationStatus {
            case .authorized, .authorizedAlways, .authorizedWhenInUse:
                authorizationStatus.send(locationManager.authorizationStatus)
            default:
                locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func fetchCurrentLocation() async throws -> CLLocation {
        locationManager.requestLocation()
        return try await withCheckedThrowingContinuation { continuation in
            location
                .prefix(1)
                .timeout(10, scheduler: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
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
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        authorizationStatus.send(completion: .failure(error))
    }
}

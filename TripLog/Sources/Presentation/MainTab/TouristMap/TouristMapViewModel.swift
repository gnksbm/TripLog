//
//  TouristMapViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/19/24.
//

import SwiftUI
import MapKit

final class TouristMapViewModel: ViewModel {
    @Injected private var locationService: LocationService
    @Injected private var touristRepository: TouristRepository
    
    @Published var state = State()
    
    private let throttle = Throttle(
        delay: 0.1,
        queue: DispatchQueue(label: "TouristMapViewModel")
    )
    
    @MainActor
    func mutate(action: Action) {
        print(action)
        switch action {
        case .onAppear:
            locationService.requestAuthorization { [weak self] status in
                guard let self else { return }
                switch status {
                case .authorized, .authorizedAlways, .authorizedWhenInUse:
                    fetchLocation { location in
                        self.fetchItems(location: location)
                    }
                default:
                    state.isUnauthorized = true
                }
            }
        case .placeSelected(let place):
            throttle.runWithCancelOnMain { [weak self] in
                withAnimation(.smooth) {
                    self?.state.showInfo = place
                }
                print(action)
            }
        case .outsideTappedForInfo:
            throttle.runOnMain { [weak self] in
                withAnimation {
                    self?.state.showInfo = nil
                }
                print(action)
            }
        case .detailButtonTapped:
            state.showDetail = true
        case .onDismissed:
            state.showDetail = false
        case .cameraDidMove(let location):
            if !state.isLoading {
                state.showRefreshButton =
                state.latestLocation.distance(from: location) > 1000
            }
        case .refreshButtonTapped:
            let location = CLLocation(
                latitude: state.region.center.latitude,
                longitude: state.region.center.longitude
            )
            state.showRefreshButton = false
            state.latestLocation = location
            fetchItems(location: location)
        case .locationButtonTapped:
            fetchLocation(completion: { _ in })
        }
    }
    
    @MainActor
    private func fetchItems(location: CLLocation) {
        Task {
            state.isLoading = true
            let touristPlaces =
            try await touristRepository.fetchTouristInformations(
                page: state.page,
                numOfPage: state.numOfPage,
                location: location
            )
            state.placeList = touristPlaces
            state.latestLocation = CLLocation(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            state.isLoading = false
        }
    }
    
    @MainActor @discardableResult
    private func fetchLocation() async throws -> CLLocation {
        let location = try await locationService.fetchCurrentLocation()
        withAnimation {
            state.region.center = location.coordinate
        }
        return location
    }
    
    private func fetchLocation(completion: @escaping (CLLocation) -> Void) {
        locationService.fetchCurrentLocation { [weak self] location in
            DispatchQueue.main.async {
                self?.state.region.center = location.coordinate
            }
            completion(location)
        }
    }
}

extension TouristMapViewModel {
    struct State {
        var page = 0
        let numOfPage = 50
        var placeList = [TouristPlaceResponse]()
        var isUnauthorized = false
        var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.56471,
                longitude: 126.97512
            ),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )
        var latestLocation = CLLocation(
            latitude: 37.56471,
            longitude: 126.97512
        )
        var showInfo: TouristPlaceResponse?
        var showDetail = false
        var showRefreshButton = false
        var isLoading = true
    }
    
    enum Action: Hashable {
        case onAppear
        case placeSelected(TouristPlaceResponse)
        case outsideTappedForInfo
        case detailButtonTapped
        case onDismissed
        case cameraDidMove(CLLocation)
        case refreshButtonTapped
        case locationButtonTapped
    }
}

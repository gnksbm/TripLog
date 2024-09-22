//
//  TouristMapViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/19/24.
//

import Foundation
import MapKit

final class TouristMapViewModel: ViewModel {
    @Injected private var locationService: LocationService
    @Injected private var touristRepository: TouristRepository
    
    @Published var state = State()
    
    func mutate(action: Action) {
        Task {
            switch action {
            case .onAppear:
                let status = try await locationService.requestAuthorization()
                switch status {
                case .authorized, .authorizedAlways, .authorizedWhenInUse:
                    let location = 
                    try await locationService.fetchCurrentLocation()
                    await MainActor.run {
                        state.region.center = location.coordinate
                    }
                    let touristPlaces =
                    try await touristRepository.fetchTouristInformations(
                        page: state.page,
                        numOfPage: state.numOfPage,
                        location: location
                    )
                    await MainActor.run {
                        state.placeList = touristPlaces
                    }
                default:
                    await MainActor.run {
                        state.isUnauthorized = true
                    }
                }
            case .placeSelected(let place):
                state.showPlace = place
            }
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
        var showPlace: TouristPlaceResponse?
//        @available(iOS 17.0, *)
//        var cameraPosition = MapCameraPosition.region(
//            MKCoordinateRegion(
//                center: CLLocationCoordinate2D(
//                    latitude: 34.011_286,
//                    longitude: -116.166_868
//                ),
//                span: MKCoordinateSpan(
//                    latitudeDelta: 0.2,
//                    longitudeDelta: 0.2
//                )
//            )
//        )
    }
    
    enum Action: Hashable {
        case onAppear
        case placeSelected(TouristPlaceResponse)
    }
}

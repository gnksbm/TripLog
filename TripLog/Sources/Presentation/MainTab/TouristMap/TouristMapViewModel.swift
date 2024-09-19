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
    
    var state = State()
    
    func mutate(action: Action) {
        Task {
            switch action {
            case .onAppear:
                let status = await locationService.requestAuthorization()
                switch status {
                case .authorized, .authorizedAlways, .authorizedWhenInUse:
                    let location = 
                    try await locationService.fetchCurrentLocation()
                    state.region.center = location.coordinate
                default:
                    state.isUnauthorized = true
                }
            }
        }
    }
}

extension TouristMapViewModel {
    struct State {
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
    
    enum Action {
        case onAppear
    }
}

//
//  EventMapViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import MapKit
import Foundation

final class EventMapViewModel: ViewModel {
    @Published var state: State
    
    init(event: TravelEvent) {
        state = State(
            eventName: event.title,
            date: event.date
        )
        if let locationInfo = event.locationInfo {
            state.region.center = CLLocationCoordinate2D(
                latitude: locationInfo.latitude,
                longitude: locationInfo.longitude
            )
            state.markerCoordinate = CLLocationCoordinate2D(
                latitude: locationInfo.latitude,
                longitude: locationInfo.longitude
            )
        }
    }
    
    func mutate(action: Action) {
        
    }
}

extension EventMapViewModel {
    struct State {
        var eventName: String
        var date: Date
        var markerCoordinate = CLLocationCoordinate2D()
        var region = MKCoordinateRegion()
    }
    
    enum Action { }
}

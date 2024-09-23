//
//  EventMapView.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D: Hashable, Identifiable {
    public static func == (
        lhs: CLLocationCoordinate2D,
        rhs: CLLocationCoordinate2D
    ) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
    
    public var id: Self { self }
}

struct EventMapView: View {
    @StateObject private var viewModel: EventMapViewModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(
                coordinateRegion: $viewModel.state.region,
                annotationItems: [viewModel.state.markerCoordinate]
            ) { coordinate in
                MapAnnotation(coordinate: coordinate) {
                    MarkerView()
                }
            }
            HStack {
                Text(viewModel.state.eventName)
                    .font(.title)
                    .bold()
                Spacer()
                Label(
                    viewModel.state.date.formatted(dateFormat: .onlyTime),
                    systemImage: "clock"
                )
                .font(.title2)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
            }
            .padding()
        }
    }
    
    init(event: TravelEvent) {
        self._viewModel = StateObject(
            wrappedValue: EventMapViewModel(event: event)
        )
    }
}

#Preview {
    EventMapView(
        event: TravelEvent(
            title: "이벤트 이름",
            date: .now.addingTimeInterval(-300),
            locationInfo: LocationInformation(
                title: "이벤트 장소",
                latitude: 37.56471,
                longitude: 126.97512
            )
        )
    )
}

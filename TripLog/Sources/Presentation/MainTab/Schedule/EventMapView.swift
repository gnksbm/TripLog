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
            .edgesIgnoringSafeArea(.all)
            
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.state.eventName)
                        .font(TLFont.headline)
                        .foregroundColor(TLColor.primaryText)
                    
                    Label(
                        viewModel.state.date.formatted(dateFormat: .onlyTime),
                        systemImage: "clock"
                    )
                    .font(TLFont.subHeadline)
                    .foregroundColor(TLColor.secondaryText)
                }
                Spacer()
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(TLColor.lightPeach.opacity(0.9))
                    .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
            }
            .padding()
        }
        .navigationTitle("이벤트 위치")
        .navigationBarTitleDisplayMode(.inline)
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
            id: "",
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

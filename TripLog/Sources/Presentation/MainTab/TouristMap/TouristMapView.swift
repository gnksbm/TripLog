//
//  TouristMapView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI
import MapKit

extension TouristPlaceResponse: Identifiable {
    var id: String { contentID }
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
}

struct TouristMapView: View {
    @StateObject private var viewModel = TouristMapViewModel()
      
    var body: some View {
        NavigationStack { 
            VStack {
                if #available(iOS 17.0, *) {
                    Map(
//                        position: $viewModel.state.cameraPosition
                    ) {
                        ForEach(viewModel.state.placeList) { place in
                            Annotation(
                                place.title,
                                coordinate: place.coordinate
                            ) {
                                MarkerView()
                                    .onTapGesture {
                                        viewModel.send(
                                            action: .placeSelected(place)
                                        )
                                    }
                            }
                        }
                    }
                } else {
                    Map(
                        coordinateRegion: $viewModel.state.region,
                        annotationItems: viewModel.state.placeList
                    ) { place in
                        MapAnnotation(coordinate: place.coordinate) {
                            MarkerView()
                                .onTapGesture {
                                    viewModel.send(
                                        action: .placeSelected(place)
                                    )
                                }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.send(action: .onAppear)
            }
        }
    }
}

#Preview {
    TouristMapView()
}

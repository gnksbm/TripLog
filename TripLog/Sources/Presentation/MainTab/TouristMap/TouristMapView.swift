//
//  TouristMapView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI
import MapKit

struct TouristMapView: View {
    @StateObject private var viewModel = TouristMapViewModel()
      
    var body: some View {
        NavigationStack { 
            VStack {
                if #available(iOS 17.0, *) {
                    Map(
//                        position: $viewModel.state.cameraPosition
                    ) {
                        
                    }
                } else {
                    Map(
                        coordinateRegion: $viewModel.state.region,
                        showsUserLocation: true
                    )
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

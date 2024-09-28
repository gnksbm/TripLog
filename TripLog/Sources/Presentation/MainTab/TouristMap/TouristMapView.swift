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
            ZStack {
                mapView
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            viewModel.send(action: .outsideTappedForInfo)
                        }
                    }
                
                if let selectedPlace = viewModel.state.showInfo {
                    VStack {
                        Spacer()
                        placeInfoView(selectedPlace)
                            .transition(
                                .move(edge: .bottom).combined(with: .opacity)
                            )
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("관광지 지도")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(
                isPresented: Binding(
                    get: { viewModel.state.showDetail },
                    set: { isPresented in
                        if !isPresented {
                            viewModel.send(action: .onDismissed)
                        }
                    }
                )
            ) {
                if let item = viewModel.state.showInfo {
                    LocationDetailView(item: item)
                }
            }
            .onAppear {
                viewModel.send(action: .onAppear)
            }
        }
    }
    
    @ViewBuilder
    var mapView: some View {
        if #available(iOS 17.0, *) {
            Map() {
                ForEach(viewModel.state.placeList) { place in
                    Annotation(
                        place.title,
                        coordinate: place.coordinate
                    ) {
                        MarkerView()
                            .onTapGesture {
                                withAnimation {
                                    viewModel.send(action: .placeSelected(place))
                                }
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
                            withAnimation {
                                viewModel.send(action: .placeSelected(place))
                            }
                        }
                }
            }
        }
    }
    
    @ViewBuilder
    func placeInfoView(_ place: TouristPlaceResponse) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(place.title)
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            Text(place.address)
                .font(TLFont.body)
                .foregroundColor(TLColor.secondaryText)
            
            Button {
                viewModel.send(action: .placeSelected(place))
            } label: {
                Text("상세 정보 보기")
                    .font(TLFont.body)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(TLColor.coralOrange)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    TouristMapView()
}

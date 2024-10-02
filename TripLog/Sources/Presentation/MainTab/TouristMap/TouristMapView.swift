//
//  TouristMapView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI
import MapKit

extension MKCoordinateSpan: Equatable {
    public static func == (
        lhs: MKCoordinateSpan,
        rhs: MKCoordinateSpan
    ) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta &&
        lhs.longitudeDelta == rhs.longitudeDelta
    }
}

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
    
    private let minSpan = MKCoordinateSpan(
        latitudeDelta: 0.005,
        longitudeDelta: 0.005
    )
    private let maxSpan = MKCoordinateSpan(
        latitudeDelta: 0.1,
        longitudeDelta: 0.1
    )
    
    private let debouncer = Debouncer(
        delay: 0.3,
        queue: DispatchQueue(label: "TouristMapView")
    )
    
    var body: some View {
        NavigationStack {
            ZStack {
                mapView
                    .onTapGesture {
                        withAnimation {
                            viewModel.send(action: .outsideTappedForInfo)
                        }
                    }
                locationButton
                if let selectedPlace = viewModel.state.showInfo {
                    VStack {
                        Spacer()
                        placeInfoView(selectedPlace)
                            .padding(.horizontal)
                            .padding(.bottom, 30)
                    }
                }
                if viewModel.state.showRefreshButton {
                    VStack {
                        Button {
                            viewModel.send(action: .refreshButtonTapped)
                        } label: {
                            Text("현 위치에서 재검색")
                                .font(TLFont.caption)
                                .bold()
                                .foregroundColor(.white)
                                .padding()
                                .background(TLColor.oceanBlue)
                                .cornerRadius(8)
                        }
                        .padding(.top)
                        Spacer()
                    }
                }
                if viewModel.state.isLoading {
                    ProgressView()
                        .controlSize(.large)
                        .tint(TLColor.deepBlue)
                }
            }
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
            .onChange(of: viewModel.state.region.span) { currentSpan in
                debouncer.runOnMain {
                    if currentSpan.latitudeDelta < minSpan.latitudeDelta {
                        viewModel.state.region.span = minSpan // 최소 줌 레벨 유지
                    } else if currentSpan.latitudeDelta > maxSpan.latitudeDelta {
                        viewModel.state.region.span = maxSpan // 최대 줌 레벨 유지
                    }
                }
            }
            .onChange(of: viewModel.state.region.center) { value in
                debouncer.runOnMain {
                    viewModel.send(
                        action: .cameraDidMove(
                            CLLocation(
                                latitude: value.latitude,
                                longitude: value.longitude
                            )
                        )
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    var mapView: some View {
//        if #available(iOS 17.0, *) {
//            Map(
//                bounds: MapCameraBounds(
//                    minimumDistance: 100,
//                    maximumDistance: 30000
//                )
//            ) {
//                ForEach(viewModel.state.placeList) { place in
//                    Annotation(
//                        place.title,
//                        coordinate: place.coordinate
//                    ) {
//                        MarkerView()
//                            .onTapGesture {
//                                withAnimation {
//                                    viewModel.send(action: .placeSelected(place))
//                                }
//                            }
//                    }
//                }
//            }
//            .onMapCameraChange { context in
//                debouncer.run {
//                    viewModel.send(
//                        action: .cameraDidMove(
//                            CLLocation(
//                                latitude: context.camera.centerCoordinate.latitude,
//                                longitude: context.camera.centerCoordinate.longitude
//                            )
//                        )
//                    )
//                }
//            }
//        } else {
//            Map(
//                coordinateRegion: $viewModel.state.region,
//                showsUserLocation: true,
//                annotationItems: viewModel.state.placeList
//            ) { place in
//                MapAnnotation(coordinate: place.coordinate) {
//                    MarkerView()
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.send(action: .placeSelected(place))
//                            }
//                        }
//                }
//            }
//        }
        Map(
            coordinateRegion: $viewModel.state.region,
            showsUserLocation: true,
            annotationItems: viewModel.state.placeList
        ) { place in
            MapAnnotation(coordinate: place.coordinate) {
                MarkerView()
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            viewModel.send(action: .placeSelected(place))
                        }
                    }
            }
        }
    }
    
    var locationButton: some View {
        VStack {
            HStack {
                Button {
                    viewModel.send(action: .locationButtonTapped)
                } label: {
                    HStack {
                        Image(systemName: "smallcircle.filled.circle")
                            .font(TLFont.subHeadline)
                        Text("현재위치")
                            .font(TLFont.caption)
                    }
                    .bold()
                    .padding(3)
                    .padding(.horizontal, 3)
                    .background(.white)
                    .foregroundStyle(TLColor.oceanBlue)
                }
                .clipShape(.capsule)
                .padding()
                Spacer()
            }
            Spacer()
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
                viewModel.send(action: .detailButtonTapped)
            } label: {
                Text("상세 정보 보기")
                    .font(TLFont.body)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(TLColor.oceanBlue)
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

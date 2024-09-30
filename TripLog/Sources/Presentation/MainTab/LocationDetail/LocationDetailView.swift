//
//  LocationDetailView.swift
//  TripLog
//
//  Created by gnksbm on 9/27/24.
//

import SwiftUI
import MapKit

import Kingfisher

struct LocationDetailView<Item: LocationInfoItemType>: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TabView {
                ForEach(item.imageURLs, id: \.hashValue) { url in
                    KFImage(url)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
            }
            .frame(height: 250)
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .padding(.horizontal, -16)
            titleView
            dateView
            addressView
            Spacer()
            navigationButton
        }
        .padding()
        .navigationTitle("상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .background(TLColor.backgroundGray.ignoresSafeArea())
    }

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
        }
    }

    private var dateView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("날짜")
                .font(TLFont.subHeadline)
                .foregroundColor(TLColor.primaryText)
            
            if let periodToStr = item.periodToStr {
                Label(periodToStr, systemImage: "calendar")
                    .font(TLFont.body)
                    .foregroundColor(TLColor.secondaryText)
            } else {
                Text("날짜 정보가 없습니다.")
                    .font(TLFont.body)
                    .foregroundColor(TLColor.secondaryText)
            }
        }
        .padding(.vertical, 8)
    }

    private var addressView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("주소")
                .font(TLFont.subHeadline)
                .foregroundColor(TLColor.primaryText)
            
            Text(item.address)
                .font(TLFont.body)
                .foregroundColor(TLColor.secondaryText)
        }
    }

    private var navigationButton: some View {
        Button {
            openMap(for: item)
        } label: {
            HStack {
                Spacer()
                Label("위치 안내 시작", systemImage: "location.fill")
                    .font(TLFont.body)
                    .foregroundColor(.white)
                    .padding()
                Spacer()
            }
            .background(Capsule().fill(TLColor.oceanBlue))
        }
    }
    
    private func openMap(for item: Item) {
        let latitude = item.latitude
        let longitude = item.longitude
        let regionDistance: CLLocationDistance = 1000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: regionDistance,
            longitudinalMeters: regionDistance
        )
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = item.title
        mapItem.openInMaps(launchOptions: options)
    }
}

#Preview {
    LocationDetailView(item: SearchFestivalResponse.mock)
}

//
//  LocationDetailView.swift
//  TripLog
//
//  Created by gnksbm on 9/27/24.
//

import SwiftUI
import MapKit

import Kingfisher

struct LocationDetailView<Item: VisibleLocationInfoType>: View {
    let item: Item
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TabView {
                    ForEach(item.imageURLs, id: \.hashValue) { url in
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                            .cornerRadius(12)
                    }
                }
                .frame(height: 250)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .padding(.horizontal, -16)
                titleView
                KFImage(nil)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()
                    .cornerRadius(12)
                dateView
                addressView
                navigationButton
            }
            .padding()
        }
        .navigationTitle("상세 정보")
        .navigationBarTitleDisplayMode(.inline)
        .background(TLColor.backgroundGray.ignoresSafeArea())
    }

    private var titleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.title)
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            if let startDate = item.startDate, let endDate = item.endDate {
                Text("\(startDate.formatted(dateFormat: .festivalOutput)) ~ \(endDate.formatted(dateFormat: .festivalOutput))")
                    .font(TLFont.caption)
                    .foregroundColor(TLColor.secondaryText)
            }
        }
    }

    private var dateView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("날짜")
                .font(TLFont.subHeadline)
                .foregroundColor(TLColor.primaryText)
            
            if let startDate = item.startDate, let endDate = item.endDate {
                HStack {
                    Label(startDate.formatted(dateFormat: .festivalOutput), systemImage: "calendar")
                    Spacer()
                    Text("부터")
                    Spacer()
                    Label(endDate.formatted(dateFormat: .festivalOutput), systemImage: "calendar")
                }
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

// 예제 데이터
struct SampleLocationInfo: VisibleLocationInfoType {
    var contentID = UUID().uuidString
    var title = "예제 장소"
    var address = "서울특별시 강남구"
    var latitude = 37.4979
    var longitude = 127.0276
    var startDate: Date? = Date()
    var endDate: Date? = Calendar.current.date(byAdding: .day, value: 7, to: Date())
    var imageURLs: [URL] = [
        URL(string: "https://example.com/image1.jpg")!,
        URL(string: "https://example.com/image2.jpg")!
    ]
}

#Preview {
    LocationDetailView(item: SampleLocationInfo())
}

//
//  FestivalCardView.swift
//  TripLog
//
//  Created by gnksbm on 9/16/24.
//

import SwiftUI

struct FestivalCardView: View {
    let festival: SearchFestivalResponse
    
    var body: some View {
        VStack {
            AsyncImage(url: festival.imageURLs.first) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(let error):
                    errorView(error)
                @unknown default:
                    EmptyView()
                }
            }
            HStack {
                Text(festival.title)
                    .font(.title2)
                    .bold()
                Spacer()
                Text("\(festival.startDate.formatted(dateFormat: .festivalOutput)) ~ \(festival.endDate.formatted(dateFormat: .festivalOutput))")
            }
            .padding()
            HStack {
                Text(festival.address)
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.bottom)
                Spacer()
            }
        }
        .background(.background)
        .clipShape(.rect(cornerRadius: 15))
        .padding(.vertical)
        .shadow(radius: 10)
    }
    
    func errorView(_ error: Error) -> some View {
        print(error)
        return Image(systemName: "xmark")
    }
}

#Preview {
    FestivalCardView(
        festival: SearchFestivalResponse(
            contentID: "2648460",
            title: "경복궁 별빛야행",
            address: "서울특별시 종로구 사직로 161 (세종로)",
            latitude: 126.9767375783,
            longitude: 37.5760836609,
            startDate: "20240911".formatted(dateFormat: .festivalInput)!,
            endDate: "20241006".formatted(dateFormat: .festivalInput)!,
            imageURLs: [
                URL(string: "http://tong.visitkorea.or.kr/cms/resource/24/3349624_image2_1.png")!,
                URL(string: "http://tong.visitkorea.or.kr/cms/resource/24/3349624_image3_1.png")!
            ]
        )
    )
}

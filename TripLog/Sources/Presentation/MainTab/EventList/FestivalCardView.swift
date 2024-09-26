//
//  FestivalCardView.swift
//  TripLog
//
//  Created by gnksbm on 9/16/24.
//

import SwiftUI

import Kingfisher

struct FestivalCardView: View {
    let festival: SearchFestivalResponse
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            KFImage(festival.imageURLs.first)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(festival.title)
                    .font(TLFont.headline)
                    .foregroundColor(TLColor.primaryText)
                    .lineLimit(2)
                
                Text("\(festival.startDate.formatted(dateFormat: .festivalOutput)) ~ \(festival.endDate.formatted(dateFormat: .festivalOutput))")
                    .font(TLFont.caption)
                    .foregroundColor(TLColor.secondaryText)
                
                Text(festival.address)
                    .font(TLFont.subHeadline)
                    .foregroundColor(TLColor.primaryText)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            .padding([.horizontal, .bottom], 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
        )
        .padding(.vertical, 8)
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

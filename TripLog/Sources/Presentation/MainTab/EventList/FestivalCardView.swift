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
                .cornerRadius(12, corners: [.topLeft, .topRight])
            
            VStack(alignment: .leading, spacing: 15) {
                Text(festival.title)
                    .font(TLFont.headline)
                    .fontWeight(.black)
                    .foregroundColor(TLColor.primaryText)
                    .lineLimit(2)
                Label {
                    Text("\(festival.startDate.formatted(dateFormat: .festivalOutput)) ~ \(festival.endDate.formatted(dateFormat: .festivalOutput))")
                        .font(TLFont.caption)
                        .bold()
                        .foregroundColor(TLColor.secondaryText)
                } icon: {
                    Image(systemName: "calendar")
                }
                Text(festival.address)
                    .font(TLFont.caption)
                    .bold()
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

#if DEBUG
#Preview {
    FestivalCardView(
        festival: .mock
    )
}
#endif

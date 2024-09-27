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
        festival: .mock
    )
}

//
//  RecordDetailView.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import SwiftUI

struct RecordDetailView: View {
    let record: TravelRecord
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                imageTabView
                    .frame(height: UIScreen.main.bounds.width * 0.75)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(record.dateStr)
                        .font(TLFont.subHeadline)
                        .foregroundColor(TLColor.secondaryText)
                    
                    Text(record.content)
                        .font(TLFont.body)
                        .foregroundColor(TLColor.primaryText)
                        .padding(.bottom, 16)
                }
                .padding(.horizontal)
            }
        }
        .background(TLColor.backgroundGray.ignoresSafeArea())
        .navigationTitle("기록 상세")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    var imageTabView: some View {
        TabView {
            if record.imageURLs.isEmpty {
                Color.secondary.opacity(0.1)
                    .overlay(
                        Text("이미지가 없습니다")
                            .font(TLFont.caption)
                            .bold()
                            .foregroundColor(TLColor.secondaryText)
                    )
            } else {
                ForEach(record.imageURLs, id: \.self) { path in
                    LocalImageView(path: path)
                        .cornerRadius(12)
                        .padding(.horizontal, 16)
                }
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    RecordDetailView(
        record: TravelRecord(
            id: "mock1",
            date: .now,
            content: "맛있는 제주도 해물칼국수",
            imageURLs: []
        )
    )
}

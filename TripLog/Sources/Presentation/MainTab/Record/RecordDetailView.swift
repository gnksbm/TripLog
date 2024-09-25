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
            Text(record.title)
                .bold()
            ForEach(record.items) { item in
                TabView {
                    if item.imageURLs.isEmpty {
                        Color.secondary
                    } else {
                        ForEach(item.imageURLs, id: \.self) { path in
                            AsyncImage(
                                url: FileManager.getLocalImageURL(
                                    additionalPath: path
                                )
                            )
                        }
                    }
                }
                Text(item.title)
                    .bold()
                Text(item.content)
            }
        }
    }
}

#Preview {
    RecordDetailView(
        record: TravelRecord(
            title: "2024 삼척 여행",
            startDate: .now.addingTimeInterval(-86400),
            endDate: .now,
            items: [
                RecordItem(
                    title: "맛집 탐방",
                    content: "해물 칼국수집 짱맛",
                    imageURLs: []
                )
            ]
        )
    )
}

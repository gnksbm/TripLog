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
            TabView {
                if record.imageURLs.isEmpty {
                    Color.secondary
                } else {
                    ForEach(record.imageURLs, id: \.self) { path in
                        LocalImageView(path: path)
                    }
                }
            }
            .frame(height: UIScreen.main.bounds.width)
            Text(record.dateStr)
            Text(record.content)
        }
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

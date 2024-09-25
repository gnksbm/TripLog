//
//  MockRecordRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

final class MockRecordRepository: RecordRepository {
    private var list = [
        TravelRecord(
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
    ]
    
    func fetchRecords() async throws -> [TravelRecord] {
        list
    }
}

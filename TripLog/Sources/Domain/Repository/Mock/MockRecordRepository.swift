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
            id: "mock1",
            date: .now,
            content: "맛있는 제주도 해물칼국수",
            imageURLs: []
        )
    ]
    
    func fetchRecords() async throws -> [TravelRecord] {
        list
    }
    
    func addRecord(
        id: String,
        date: Date,
        content: String,
        imageURLs: [String]
    ) async throws {
        let newRecord = TravelRecord(
            id: id,
            date: date,
            content: content,
            imageURLs: imageURLs
        )
        list.append(newRecord)
    }
}

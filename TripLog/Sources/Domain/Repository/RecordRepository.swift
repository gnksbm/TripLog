//
//  RecordRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

protocol RecordRepository {
    func fetchRecords() async throws -> [TravelRecord]
    func addRecord(
        id: String,
        date: Date,
        content: String,
        imageURLs: [String]
    ) async throws 
}

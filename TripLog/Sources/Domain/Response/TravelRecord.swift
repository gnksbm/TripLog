//
//  TravelRecord.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

struct TravelRecord: Hashable {
    let id: String
    let date: Date
    let content: String
    let imageURLs: [String]
    
    var dateStr: String { date.formatted(dateFormat: .festivalOutput) }
}

extension TravelRecord: Identifiable { }

struct RecordItem: Hashable {
    let id: String = UUID().uuidString
    let title: String
    let content: String
    let imageURLs: [String]
}

extension RecordItem: Identifiable { }

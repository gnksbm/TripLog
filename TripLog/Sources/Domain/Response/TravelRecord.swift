//
//  TravelRecord.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

struct TravelRecord: Hashable {
    let id: String = UUID().uuidString
    let title: String
    let startDate: Date
    let endDate: Date
    var items: [RecordItem]
    
    var peoridStr: String {
        startDate.formatted(dateFormat: .festivalOutput) +
        " ~ " +
        endDate.formatted(dateFormat: .festivalOutput)
    }
    
    var thumbnailContent: String? {
        items.first { item in !item.content.isEmpty }?.content
    }
    
    var thumbnailImageURL: String? {
        items.first { item in !item.imageURLs.isEmpty }?.imageURLs.first
    }
}

extension TravelRecord: Identifiable { }

struct RecordItem: Hashable {
    let id: String = UUID().uuidString
    let title: String
    let content: String
    let imageURLs: [String]
}

extension RecordItem: Identifiable { }

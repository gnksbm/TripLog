//
//  LocationInfoItemType.swift
//  TripLog
//
//  Created by gnksbm on 9/27/24.
//

import Foundation

protocol LocationInfoItemType {
    var contentID: String { get }
    var title: String { get }
    var address: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var period: DateInterval? { get }
    var imageURLs: [URL] { get }
}

extension LocationInfoItemType {
    var periodToStr: String? {
        guard let period else { return nil }
        return period.start.formatted(dateFormat: .festivalOutput) +
        " ~ " +
        period.end.formatted(dateFormat: .festivalOutput)
    }
}

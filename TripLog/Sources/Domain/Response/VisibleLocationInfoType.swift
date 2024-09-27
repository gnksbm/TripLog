//
//  VisibleLocationInfoType.swift
//  TripLog
//
//  Created by gnksbm on 9/27/24.
//

import Foundation

protocol VisibleLocationInfoType {
    var contentID: String { get }
    var title: String { get }
    var address: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var startDate: Date? { get }
    var endDate: Date? { get }
    var imageURLs: [URL] { get }
}

extension VisibleLocationInfoType {
    var startDate: Date? { nil }
    var endDate: Date? { nil }
}

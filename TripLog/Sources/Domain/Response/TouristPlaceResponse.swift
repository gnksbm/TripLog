//
//  TouristPlaceResponse.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

struct TouristPlaceResponse: Hashable, LocationInfoItemType {
    let contentID: String
    let contentTypeID: String
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    let imageURLs: [URL]
}

extension TouristPlaceResponse {
    var period: DateInterval? { nil }
}

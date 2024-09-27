//
//  TouristPlaceResponse.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

struct TouristPlaceResponse: Hashable, VisibleLocationInfoType {
    let contentID: String
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    let imageURLs: [URL]
}

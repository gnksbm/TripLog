//
//  SearchFestivalResponse.swift
//  TripLog
//
//  Created by gnksbm on 9/16/24.
//

import Foundation

struct SearchFestivalResponse {
    let contentID: String
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    let startDate: Date
    let endDate: Date
    let imageURLs: [URL]
}

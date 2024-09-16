//
//  SearchFestivalRequest.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

struct SearchFestivalRequest {
    let areaCode: Int?
    let eventStartDate: Date
    let eventEndDate: Date?
}

extension SearchFestivalRequest: QueryProvider {
    var query: Query {
        Query(
            areaCode: areaCode,
            eventStartDate: eventStartDate.formatted(
                dateFormat: .searchFestivalRequest
            ),
            eventEndDate: eventEndDate?.formatted(
                dateFormat: .searchFestivalRequest
            )
        )
    }
    
    struct Query: Encodable {
        let areaCode: Int?
        let eventStartDate: String
        let eventEndDate: String?
    }
}

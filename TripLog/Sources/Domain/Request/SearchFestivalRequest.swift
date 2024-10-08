//
//  SearchFestivalRequest.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

struct SearchFestivalRequest {
    let pageNo: Int?
    let numOfRows: Int?
    let areaCode: Int?
    let eventStartDate: Date
    let eventEndDate: Date?
}

extension SearchFestivalRequest: QueryProvider {
    var query: Query {
        Query(
            pageNo: pageNo,
            numOfRows: numOfRows,
            areaCode: areaCode,
            eventStartDate: eventStartDate.formatted(
                dateFormat: .festivalInput
            ),
            eventEndDate: eventEndDate?.formatted(
                dateFormat: .festivalInput
            )
        )
    }
    
    struct Query: Encodable {
        let pageNo: Int?
        let numOfRows: Int?
        let areaCode: Int?
        let eventStartDate: String
        let eventEndDate: String?
    }
}

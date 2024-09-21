//
//  TouristInformationRequest.swift
//  TripLog
//
//  Created by gnksbm on 9/21/24.
//

import Foundation

struct TouristInformationRequest {
    let pageNo: Int
    let numOfPage: Int
    let latitude: Double
    let longitude: Double
}

extension TouristInformationRequest: QueryProvider {
    var query: Query {
        Query(
            pageNo: pageNo,
            numOfRows: numOfPage,
            mapX: longitude,
            mapY: latitude
        )
    }
    
    struct Query: Encodable {
        let pageNo: Int
        let numOfRows: Int
        let mapX: Double
        let mapY: Double
        let radius: Int = 20000
    }
}

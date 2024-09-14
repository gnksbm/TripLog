//
//  AreaCodeRequest.swift
//  TripLog
//
//  Created by gnksbm on 9/14/24.
//

import Foundation

struct AreaCodeRequest {
    let numOfRows: Int
    let pageNo: Int
    let areaCode: String?
}

extension AreaCodeRequest: QueryProvider {
    var query: Query {
        Query(
            numOfRows: numOfRows,
            pageNo: pageNo,
            areaCode: areaCode
        )
    }
    
    struct Query: Encodable {
        let numOfRows: Int
        let pageNo: Int
        let areaCode: String?
    }
}

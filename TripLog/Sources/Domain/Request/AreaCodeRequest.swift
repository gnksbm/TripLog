//
//  AreaCodeRequest.swift
//  TripLog
//
//  Created by gnksbm on 9/14/24.
//

import Foundation

struct AreaCodeRequest {
    let numOfRows: Int?
    let pageNo: Int?
    let areaCode: String?
    
    init(
        numOfRows: Int? = nil,
        pageNo: Int? = nil,
        areaCode: String? = nil
    ) {
        self.numOfRows = numOfRows
        self.pageNo = pageNo
        self.areaCode = areaCode
    }
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
        let numOfRows: Int?
        let pageNo: Int?
        let areaCode: String?
    }
}

//
//  DetailCommonRequest.swift
//  TripLog
//
//  Created by gnksbm on 10/4/24.
//

import Foundation

struct DetailCommonRequest {
    let contentID: String
    let contentTypeID: String
}

extension DetailCommonRequest: QueryProvider {
    var query: Query {
        Query(
            contentID: contentID,
            contentTypeID: contentTypeID
        )
    }
    
    struct Query: Encodable {
        let contentID: String
        let contentTypeID: String
        
        enum CodingKeys: String, CodingKey {
            case contentID = "contentId"
            case contentTypeID = "contentTypeId"
        }
    }
}

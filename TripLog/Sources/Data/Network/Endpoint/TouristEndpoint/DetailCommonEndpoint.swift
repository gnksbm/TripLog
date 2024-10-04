//
//  DetailCommonEndpoint.swift
//  TripLog
//
//  Created by gnksbm on 10/4/24.
//

import Foundation

struct DetailCommonEndpoint: TouristEndpoint {
    let request: DetailCommonRequest
    
    var additionalPath: String { "/detailCommon1" }
    var queryParameters: [String : String] { request.queryToDic() }
}

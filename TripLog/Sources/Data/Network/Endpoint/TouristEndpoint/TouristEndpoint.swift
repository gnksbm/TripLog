//
//  TouristEndpoint.swift
//  TripLog
//
//  Created by gnksbm on 9/14/24.
//

import Foundation

protocol TouristEndpoint: Endpoint {
    var queryParameters: [String: String] { get }
}

extension TouristEndpoint {
    var scheme: Scheme { .http }
    var host: String { Secret.baseURL }
    var httpMethod: HTTPMethod { .get }
    var queryParameters: [String: String] { [:] }
    var queries: [String : String]? {
        [
            "MobileOS": "iOS",
            "MobileApp": "TripLog",
            "serviceKey": Secret.touristSecertKey,
            "_type": "json",
        ].merging(queryParameters) { $1 }
    }
}

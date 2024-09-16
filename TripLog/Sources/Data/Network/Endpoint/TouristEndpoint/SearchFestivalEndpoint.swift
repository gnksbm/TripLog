//
//  SearchFestivalEndpoint.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

struct SearchFestivalEndpoint: TouristEndpoint {
    let request: SearchFestivalRequest
    
    var additionalPath: String { "/searchFestival1" }
    var queryParameters: [String : String] { request.toDic() }
}

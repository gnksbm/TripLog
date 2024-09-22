//
//  TouristPlaceEndpoint.swift
//  TripLog
//
//  Created by gnksbm on 9/21/24.
//

import Foundation

struct TouristPlaceEndpoint: TouristEndpoint {
    let request: TouristPlaceRequest
    
    var additionalPath: String { "/locationBasedList1" }
    var queryParameters: [String : String] { request.toDic() }
}

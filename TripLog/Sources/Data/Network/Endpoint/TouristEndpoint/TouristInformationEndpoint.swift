//
//  TouristInformationEndpoint.swift
//  TripLog
//
//  Created by gnksbm on 9/21/24.
//

import Foundation

struct TouristInformationEndpoint: TouristEndpoint {
    let request: TouristInformationRequest
    
    var additionalPath: String { "/locationBasedList1" }
    var queryParameters: [String : String] { request.toDic() }
}

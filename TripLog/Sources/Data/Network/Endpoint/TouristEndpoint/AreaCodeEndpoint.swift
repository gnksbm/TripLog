//
//  AreaCodeEndpoint.swift
//  TripLog
//
//  Created by gnksbm on 9/14/24.
//

import Foundation

struct AreaCodeEndpoint: TouristEndpoint {
    let request: AreaCodeRequest
    var path: String { "/B551011/KorService1/areaCode1" }
    var queryParameters: [String : String] { request.toDic() }
}

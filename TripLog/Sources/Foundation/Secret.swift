//
//  Secret.swift
//  TripLog
//
//  Created by gnksbm on 9/14/24.
//

import Foundation

enum Secret {
    static var baseURL = Bundle.main.object(
        forInfoDictionaryKey: "BASE_URL"
    ) as? String ?? ""
    static var touristSecertKey = Bundle.main.object(
        forInfoDictionaryKey: "TOURIST_SECRET_KEY"
    ) as? String ?? ""
}

//
//  QueryProvider.swift
//  TripLog
//
//  Created by gnksbm on 9/14/24.
//

import Foundation

protocol QueryProvider {
    associatedtype Query: Encodable
    
    var query: Query { get }
}

extension QueryProvider {
    func toDic() -> [String: String] {
        do {
            let data = try JSONEncoder().encode(query)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let dic = jsonObject as? [String: String] else { return [:] }
            return dic
        } catch {
            return [:]
        }
    }
}

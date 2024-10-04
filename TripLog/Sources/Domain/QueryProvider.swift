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
    func queryToDic() -> [String: String] {
        do {
            let data = try JSONEncoder().encode(query)
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            guard let dic = jsonObject as? [String: Any] else { return [:] }
            return dic.compactMapValues { value in
                if let strValue = value as? String {
                    strValue
                } else if let intValue = value as? Int {
                    String(intValue)
                } else if let doubleValue = value as? Double {
                    String(doubleValue)
                } else {
                    nil
                }
            }
        } catch {
            return [:]
        }
    }
}

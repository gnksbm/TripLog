//
//  Data+.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

extension Data {
    func decode<T: Decodable>(type: T.Type) throws -> T {
        do {
            return try JSONDecoder().decode(type, from: self)
        } catch {
            print(String(data: self, encoding: .utf8) ?? "nil")
            dump(error)
            throw error
        }
    }
}

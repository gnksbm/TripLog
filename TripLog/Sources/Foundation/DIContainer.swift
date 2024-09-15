//
//  DIContainer.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

public enum DIContainer {
    static var storage = [String: Any]()
    
    public static func register<T>(_ value: T, type: T.Type) {
        storage["\(type)"] = value
    }
    
    public static func resolve<T>(type: T.Type) -> T {
        guard let object = storage["\(type)"] as? T else {
            fatalError("등록되지 않은 객체 호출: \(type)")
        }
        return object
    }
}

//
//  Injected.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

@propertyWrapper
public struct Injected<T> {
    public var wrappedValue: T {
        DIContainer.resolve(type: T.self)
    }
    
    public init() { }
}

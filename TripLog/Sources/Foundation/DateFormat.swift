//
//  DateFormat.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

public enum DateFormat: String {
    case festivalInput = "yyyyMMdd"
    case festivalOutput = "yyyy.MM.dd"
    case onlyDay = "dd"
    case onlyTime = "hh:mm"
}

extension DateFormat {
    private static var cachedStorage = [DateFormat: DateFormatter]()
    
    var formatter: DateFormatter {
        if let formatter = Self.cachedStorage[self] {
            return formatter
        } else {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = rawValue
            newFormatter.locale = Locale(identifier: "ko_KR")
            Self.cachedStorage[self] = newFormatter
            return newFormatter
        }
    }
}

public extension String {
    func formatted(dateFormat: DateFormat) -> Date? {
        dateFormat.formatter.date(from: self)
    }
    
    func formatted(input: DateFormat, output: DateFormat) -> String? {
        input.formatter.date(from: self)?.formatted(dateFormat: output)
    }
    
    func iso8601Formatted() -> Date? {
        ISO8601DateFormatter.shared.date(from: self)
    }
}

public extension Date {
    func formatted(dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
}

extension ISO8601DateFormatter {
    static let shared = ISO8601DateFormatter()
}

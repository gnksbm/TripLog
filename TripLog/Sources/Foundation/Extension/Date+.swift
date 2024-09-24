//
//  Date+.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

extension Date {
    static let calendar = Calendar.autoupdatingCurrent
    
    static func getMonth(offset: Int) -> Int {
        guard let date = calendar.date(
            byAdding: .month,
            value: offset,
            to: Date.now
        ) else { return 0 }
        return Self.calendar.component(.month, from: date)
    }
    
    static func getDatesInMonth(offset: Int) -> [Date] {
        guard let date = calendar.date(
            byAdding: .month,
            value: offset,
            to: Date.now
        ),
              let startDay = calendar.date(
                from: calendar.dateComponents([.month, .year], from: date)
              ),
              let range = calendar.range(
                of: .day,
                in: .month,
                for: startDay
              )
        else { return [] }
        return range.compactMap { value in
            calendar.date(byAdding: .day, value: value - 1, to: startDay)
        }
    }
    
    var month: Int { Self.calendar.component(.month, from: self) }
    
    var isPast: Bool {
        Date.now.distance(to: self) < 0
    }
    
    func isSameDate(_ from: Date) -> Bool {
        Self.calendar.component(.day, from: self) ==
        Self.calendar.component(.day, from: from)
    }
    
    func isSameMonth(_ month: Int) -> Bool {
        Self.calendar.component(.month, from: self) == month
    }
}

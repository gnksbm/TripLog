//
//  Date+.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

extension Date {
    static let calendar = Calendar.autoupdatingCurrent
    
    var month: Int { Self.calendar.component(.month, from: self) }
    
    func isSameDate(_ from: Date) -> Bool {
        Self.calendar.isDateInToday(from)
    }
    
    func isSameMonth(_ month: Int) -> Bool {
        Self.calendar.component(.month, from: self) == month
    }
    
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
}

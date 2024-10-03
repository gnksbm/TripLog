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
    
    var isToday: Bool { Self.calendar.isDateInToday(self) }
    var isPast: Bool { Date.now.distance(to: self) < 0 }
    
    
    func isSameDate(_ from: Date) -> Bool {
        Self.calendar.dateComponents([.year, .month, .day], from: self) ==
        Self.calendar.dateComponents([.year, .month, .day], from: from)
    }
    
    func isSameMonth(_ month: Int) -> Bool {
        Self.calendar.component(.month, from: self) == month
    }
    
    static func now(with components: [Int: Calendar.Component]) -> Date {
        var date = Date.now
        components.forEach { interval, component in
            if let newDate = Self.calendar.date(
                bySetting: component, 
                value: interval,
                of: date
            ) {
                date = newDate
            }
        }
        return date
    }
}

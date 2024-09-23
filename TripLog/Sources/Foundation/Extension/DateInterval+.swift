//
//  DateInterval+.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

extension DateInterval {
    var datesInPeriod: [Date] {
        let calendar = Calendar.autoupdatingCurrent
        var dates = [Date]()
        let startDay = calendar.startOfDay(for: start)
        let components = calendar.dateComponents(
            [.day],
            from: startDay,
            to: end
        )
        let dayDiff = components.day ?? 0
        (0...dayDiff).forEach { day in
            if let date = calendar.date(
                byAdding: .day,
                value: day,
                to: startDay
            ) {
                dates.append(date)
            }
        }
        return dates
    }
    
    init(first: Date, second: Date) {
        if first.distance(to: second) > 0 {
            self.init(start: first, end: second)
        } else {
            self.init(start: second, end: first)
        }
    }
}

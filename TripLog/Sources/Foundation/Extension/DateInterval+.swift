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
        let components = calendar.dateComponents([.day], from: start, to: end)
        let dayDiff = components.day ?? 0
        (0...dayDiff).forEach { day in
            if let date = calendar.date(
                byAdding: .day,
                value: day,
                to: start
            ) {
                dates.append(date)
            }
        }
        return dates
    }
}

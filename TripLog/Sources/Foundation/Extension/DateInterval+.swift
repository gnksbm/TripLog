//
//  DateInterval+.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

extension DateInterval {
    var distanceFromToday: String {
        var result = "날짜 정보 오류"
        if isContained(date: .now) {
            if let distance = Calendar.current.dateComponents(
                [.day],
                from: start,
                to: .now
            ).day {
                result = "Day \(distance + 1)"
            }
        } else {
            if !start.isPast {
                if let distance = Calendar.current.dateComponents(
                    [.day],
                    from: .now,
                    to: start
                ).day {
                    result = "D-\(distance)"
                }
            } else {
                if let distance = Calendar.current.dateComponents(
                    [.day],
                    from: end,
                    to: .now
                ).day {
                    result = "D+\(distance)"
                }
            }
        }
        return result
    }
    
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
    
    var periodProgress: CGFloat? {
        guard let index = datesInPeriod.firstIndex(
                  where: { date in
                      date.isToday
                  }
              )
        else {
            if !start.isPast {
                return 0
            } else {
                return 1
            }
        }
        return CGFloat(index + 1) / CGFloat(datesInPeriod.count)
    }
    
    func isContained(date: Date) -> Bool {
        datesInPeriod.contains { compare in
            compare.isSameDate(date)
        }
    }
    
    init(first: Date, second: Date) {
        if first.distance(to: second) > 0 {
            self.init(start: first, end: second)
        } else {
            self.init(start: second, end: first)
        }
    }
}

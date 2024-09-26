//
//  TravelSchedule.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

struct TravelSchedule: Hashable {
    let id: String
    let title: String
    let startDate: Date
    let endDate: Date
    var events: [TravelEvent]
    
    init(
        id: String = UUID().uuidString,
        title: String,
        startDate: Date,
        endDate: Date,
        events: [TravelEvent] = []
    ) {
        self.id = id
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.events = events
    }
    
    var dateInterval: DateInterval {
        DateInterval(start: startDate, end: endDate)
    }
}

struct TravelEvent: Hashable {
    let id: String
    let title: String
    let date: Date
    var locationInfo: LocationInformation?
}

extension TravelEvent: Identifiable { }
    
struct LocationInformation: Hashable {
    var title: String
    let latitude: Double
    let longitude: Double
}

//
//  TravelScheduleDTO.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

import RealmSwift

final class TravelScheduleDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var events: List<TravelEventDTO>
    
    convenience init(
        _ entity: TravelSchedule
    ) {
        self.init()
        id = entity.id
        title = entity.title
        startDate = entity.startDate
        endDate = entity.endDate
    }
}

extension TravelScheduleDTO {
    func toDomain() -> TravelSchedule {
        TravelSchedule(
            id: id,
            title: title,
            startDate: startDate,
            endDate: endDate,
            events: events.map { $0.toDomain() }
                .sorted(by: { $0.date > $1.date })
        )
    }
}

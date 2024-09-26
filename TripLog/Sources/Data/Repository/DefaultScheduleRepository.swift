//
//  DefaultScheduleRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

import RealmSwift

final class DefaultScheduleRepository: ScheduleRepository {
    @Injected private var realmStorage: RealmStorage
    
    func fetchSchedule() throws -> [TravelSchedule] {
        realmStorage.read(TravelScheduleDTO.self).map { $0.toDomain() }
    }
    
    func addSchedule(schedule: TravelSchedule) throws {
        try realmStorage.create(TravelScheduleDTO(schedule))
    }
    
    func addEvent(scheduleID: String, event: TravelEvent) throws {
        let schedule = try realmStorage.read(
            TravelScheduleDTO.self,
            uniqueKeyPath: \.id,
            value: scheduleID
        )
        try realmStorage.update(schedule) { schedule in
            schedule.events.append(TravelEventDTO(event))
        }
    }
}

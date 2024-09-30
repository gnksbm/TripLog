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
    
    func updateSchedule(schedule: TravelSchedule) throws {
        var oldValue = try realmStorage.read(
            TravelScheduleDTO.self,
            uniqueKeyPath: \.id,
            value: schedule.id
        )
        try realmStorage.update(oldValue) { value in
            value.title = schedule.title
            value.startDate = schedule.startDate
            value.endDate = schedule.endDate
        }
    }
    
    func updateEvent(scheduleID: String, event: TravelEvent) throws {
        let schedule = try realmStorage.read(
            TravelScheduleDTO.self,
            uniqueKeyPath: \.id,
            value: scheduleID
        )
        try realmStorage.update(schedule) { schedule in
            if let index = schedule.events.firstIndex(where: { $0.id == event.id }) {
                var oldEvent = schedule.events[index]
                oldEvent.title = event.title
                oldEvent.date = event.date
                oldEvent.locationInfo = LocationInformationDTO(event.locationInfo)
                schedule.events[index] = oldEvent
            }
        }
    }
    
    func removeSchedule(schedule: TravelSchedule) throws {
        let schedule = try realmStorage.read(
            TravelScheduleDTO.self,
            uniqueKeyPath: \.id,
            value: schedule.id
        )
        try realmStorage.delete(schedule)
    }
    
    func removeEvent(scheduleID: String, event: TravelEvent) throws {
        let schedule = try realmStorage.read(
            TravelScheduleDTO.self,
            uniqueKeyPath: \.id,
            value: scheduleID
        )
        try realmStorage.update(schedule) { schedule in
            if let index = schedule.events.firstIndex(
                where: { $0.id != event.id }
            ) {
                schedule.events.remove(at: index)
            }
        }
    }
}

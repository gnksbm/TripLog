//
//  ScheduleRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import Foundation

protocol ScheduleRepository {
    func fetchSchedule() throws -> [TravelSchedule]
    func addSchedule(schedule: TravelSchedule) throws
    func addEvent(scheduleID: String, event: TravelEvent) throws
    func updateSchedule(schedule: TravelSchedule) throws
    func updateEvent(scheduleID: String, event: TravelEvent) throws
    func removeSchedule(schedule: TravelSchedule) throws
    func removeEvent(scheduleID: String, event: TravelEvent) throws
}

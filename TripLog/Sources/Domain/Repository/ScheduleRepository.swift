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
}

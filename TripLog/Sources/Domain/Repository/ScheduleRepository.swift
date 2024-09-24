//
//  ScheduleRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import Foundation

protocol ScheduleRepository {
    func fetchSchedule() async throws -> [TravelSchedule]
    func addSchedule(schedule: TravelSchedule) async throws
    func addEvent(scheduleID: String, event: TravelEvent) async throws
}

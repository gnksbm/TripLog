//
//  MockScheduuleRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import Foundation

#if DEBUG
final class MockScheduleRepository: ScheduleRepository {
    private var scheduleList = [
        TravelSchedule(
            title: "여행계획1",
            startDate: .now.addingTimeInterval(-86400 * 4),
            endDate: .now.addingTimeInterval(86400 * 6),
            events: [
                TravelEvent(
                    title: "일정1",
                    date: .now.addingTimeInterval(-86400 * 3),
                    locationInfo: LocationInformation(
                        title: "장소1",
                        latitude: 37.56471,
                        longitude: 126.97512
                    )
                ),
                TravelEvent(
                    title: "일정2",
                    date: .now.addingTimeInterval(-86400 * 2)
                ),
                TravelEvent(
                    title: "일정3",
                    date: .now.addingTimeInterval(86400 * 1)
                ),
            ]
        ),
        TravelSchedule(
            title: "여행계획2",
            startDate: .now.addingTimeInterval(-86400 * 4),
            endDate: .now.addingTimeInterval(86400 * 6),
            events: [
                TravelEvent(
                    title: "일정1",
                    date: .now.addingTimeInterval(-86400 * 3),
                    locationInfo: LocationInformation(
                        title: "장소1",
                        latitude: 37.56471,
                        longitude: 126.97512
                    )
                ),
                TravelEvent(
                    title: "일정2",
                    date: .now.addingTimeInterval(-86400 * 2)
                ),
                TravelEvent(
                    title: "일정3",
                    date: .now.addingTimeInterval(86400 * 1)
                ),
            ]
        ),
    ]
    
    func fetchSchedule() async throws -> [TravelSchedule] {
        scheduleList
    }
    
    func addSchedule(schedule: TravelSchedule) async throws {
        scheduleList.append(schedule)
    }
    
    func addEvent(scheduleID: String, event: TravelEvent) async throws {
        if let index = scheduleList.firstIndex(
            where: { schedule in
                schedule.id == scheduleID
            }
        ) {
            scheduleList[index].events.append(event)
        }
    }
}
#endif

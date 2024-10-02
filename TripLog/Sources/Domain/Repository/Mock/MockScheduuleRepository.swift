//
//  MockScheduuleRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import Foundation

#if DEBUG
final class MockScheduleRepository: ScheduleRepository {
    private var scheduleList = TravelSchedule.mock
    
    func fetchSchedule() throws -> [TravelSchedule] {
        scheduleList
    }
    
    func addSchedule(schedule: TravelSchedule) throws {
        scheduleList.append(schedule)
    }
    
    func addEvent(scheduleID: String, event: TravelEvent) throws {
        if let index = scheduleList.firstIndex(
            where: { schedule in
                schedule.id == scheduleID
            }
        ) {
            scheduleList[index].events.append(event)
        }
    }
    
    func updateSchedule(schedule: TravelSchedule) throws { }
    func updateEvent(scheduleID: String, event: TravelEvent) throws { }
    func removeSchedule(schedule: TravelSchedule) throws { }
    func removeEvent(scheduleID: String, event: TravelEvent) throws { }
}

extension TravelSchedule {
    static let mock = [
        TravelSchedule(
            id: UUID().uuidString,
            title: "제주도 여행",
            startDate: Date().addingTimeInterval(-86400),
            endDate: Date().addingTimeInterval(86400 * 7),
            events: [
                TravelEvent(
                    id: UUID().uuidString,
                    title: "지난 이벤트",
                    date: Date().addingTimeInterval(-86400)
//                    locationInfo: LocationInformation(
//                        title: "협재 해변",
//                        latitude: 33.394814,
//                        longitude: 126.239628
//                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "지난 이벤트",
                    date: Date().addingTimeInterval(-86400)
//                    locationInfo: LocationInformation(
//                        title: "협재 해변",
//                        latitude: 33.394814,
//                        longitude: 126.239628
//                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "지난 이벤트",
                    date: Date().addingTimeInterval(-86400)
//                    locationInfo: LocationInformation(
//                        title: "협재 해변",
//                        latitude: 33.394814,
//                        longitude: 126.239628
//                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "우도 자전거 투어",
                    date: Date.now(
                        with: [
                            12: .hour,
                            0: .minute
                        ]
                    )
//                    locationInfo: LocationInformation(
//                        title: "협재 해변",
//                        latitude: 33.394814,
//                        longitude: 126.239628
//                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "메이즈랜드",
                    date: Date.now(
                        with: [
                            12: .hour,
                            0: .minute
                        ]
                    )
//                    locationInfo: LocationInformation(
//                        title: "협재 해변",
//                        latitude: 33.394814,
//                        longitude: 126.239628
//                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "에코파크 테마랜드",
                    date: Date.now(
                        with: [
                            15: .hour,
                            0: .minute
                        ]
                    )
//                    locationInfo: LocationInformation(
//                        title: "협재 해변",
//                        latitude: 33.394814,
//                        longitude: 126.239628
//                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "협재 해변에서 휴식",
                    date: Date().addingTimeInterval(86400 * 6),
                    locationInfo: LocationInformation(
                        title: "협재 해변",
                        latitude: 33.394814,
                        longitude: 126.239628
                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "성산일출봉 등반",
                    date: Date().addingTimeInterval(86400 * 7),
                    locationInfo: LocationInformation(
                        title: "성산일출봉",
                        latitude: 33.458606,
                        longitude: 126.943133
                    )
                )
            ]
        ),
        TravelSchedule(
            id: UUID().uuidString,
            title: "서울 탐방",
            startDate: Date().addingTimeInterval(-86400 * 7),
            endDate: Date().addingTimeInterval(86400 * 1),
            events: [
                TravelEvent(
                    id: UUID().uuidString,
                    title: "경복궁 방문",
                    date: Date().addingTimeInterval(-86400 * 6),
                    locationInfo: LocationInformation(
                        title: "경복궁",
                        latitude: 37.579617,
                        longitude: 126.977041
                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "광장시장 음식 탐방",
                    date: Date().addingTimeInterval(-86400 * 5),
                    locationInfo: LocationInformation(
                        title: "광장시장",
                        latitude: 37.57019,
                        longitude: 126.999742
                    )
                ),
                TravelEvent(
                    id: UUID().uuidString,
                    title: "서울타워 야경",
                    date: Date().addingTimeInterval(-86400 * 2),
                    locationInfo: LocationInformation(
                        title: "서울타워",
                        latitude: 37.551169,
                        longitude: 126.988227
                    )
                )
            ]
        ),
    ]
}
#endif

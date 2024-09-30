//
//  ScheduleListViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

final class ScheduleListViewModel: ViewModel {
    @Injected private var scheduleRepository: ScheduleRepository
    
    @Published var state = State()
    
    func mutate(action: Action) {
        switch action {
        case .onAppear, .onDismissed:
            refreshSchedule()
        case .onMapDismissed:
            state.showMapView = nil
        case .addButtonTapped:
            state.showAddView = true
        case .dateSelected(let date):
            state.selectedDate = date
            state.eventList = state.selectedSchedule?.events
                .filter { event in
                    event.date.isSameDate(date)
                } ?? []
        case .mapButtonTapped(let event):
            state.showMapView = event
        case .addEventButtonTapped:
            state.showAddEventView = true
        case .showScheduleDetail(let schedule):
            state.showScheduleDetail = true
            state.selectedDetailSchedule = schedule
        }
    }
    
    private func refreshSchedule() {
        do {
            let schedules = try scheduleRepository.fetchSchedule()
            state.scheduleList = schedules
        } catch {
            dump(error)
        }
    }
}

extension ScheduleListViewModel {
    struct State {
        var selectedIndex = 0
        var selectedDate: Date?
        var scheduleList = [TravelSchedule]()
        var showAddView = false
        var eventList = [TravelEvent]()
        var showMapView: TravelEvent?
        var showAddEventView = false
        var showScheduleDetail = false
        var selectedDetailSchedule: TravelSchedule?
        
        var selectedSchedule: TravelSchedule? {
            scheduleList.count - 1 >= selectedIndex ?
            scheduleList[selectedIndex] : nil
        }
    }
    
    enum Action {
        case onAppear
        case onDismissed
        case onMapDismissed
        case addButtonTapped
        case dateSelected(Date)
        case mapButtonTapped(TravelEvent)
        case addEventButtonTapped
        case showScheduleDetail(TravelSchedule)
    }
}

extension ScheduleListViewModel: CompleteDelegate {
    func onComplete() {
        refreshSchedule()
    }
}

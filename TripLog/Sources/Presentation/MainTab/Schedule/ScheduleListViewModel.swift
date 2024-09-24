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
        Task {
            switch action {
            case .onAppear, .onDismissed:
                refreshSchedule()
            case .onMapDismissed:
                await MainActor.run {
                    state.showMapView = nil
                }
            case .addButtonTapped:
                await MainActor.run {
                    state.showAddView = true
                }
            case .dateSelected(let date):
                await MainActor.run {
                    state.selectedDate = date
                    state.eventList = state.selectedSchedule?.events
                        .filter { event in
                            event.date.isSameDate(date)
                        } ?? []
                }
            case .mapButtonTapped(let event):
                await MainActor.run {
                    state.showMapView = event
                }
            case .addEventButtonTapped:
                await MainActor.run {
                    state.showAddEventView = true
                }
            }
        }
    }
    
    private func refreshSchedule() {
        Task {
            let schedules = try await scheduleRepository.fetchSchedule()
            await MainActor.run {
                state.scheduleList = schedules
            }
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
    }
}

extension ScheduleListViewModel: AddEventViewModelDelegate {
    func addEventCompleted() {
        refreshSchedule()
    }
}

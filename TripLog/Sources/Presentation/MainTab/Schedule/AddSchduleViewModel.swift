//
//  AddSchduleViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import Foundation

final class AddSchduleViewModel: ViewModel {
    @Injected private var scheduleRespository: ScheduleRepository
    @Published var state = State()
    
    func mutate(action: Action) {
        Task {
            switch action {
            case .intervalSelected(let interval):
                state.selectedDateInterval = interval
            case .doneButtonTapped:
                guard let dateInterval = state.selectedDateInterval 
                else { return }
                try await scheduleRespository.addSchedule(
                    schedule: TravelSchedule(
                        title: state.scheduleTitle,
                        startDate: dateInterval.start,
                        endDate: dateInterval.end
                    )
                )
                state.isCompleted = true
            }
        }
    }
}

extension AddSchduleViewModel {
    struct State {
        var selectedDateInterval: DateInterval?
        var scheduleTitle = ""
        var isCompleted = false
        
        var isDoneButtonDisabled: Bool {
            selectedDateInterval == nil || scheduleTitle.isEmpty
        }
    }
    
    enum Action {
        case intervalSelected(DateInterval)
        case doneButtonTapped
    }
}

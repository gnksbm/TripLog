//
//  ScheduleListViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

final class ScheduleListViewModel: ViewModel {
    @Published var state = State()
    
    func mutate(action: Action) {
        switch action {
        case .addButtonTapped:
            state.showAddView = true
        case .dateSelected(let date):
            state.selectedDate = date
        }
    }
}

extension ScheduleListViewModel {
    struct State {
        var selectedSchdule: TravelSchedule?
        var selectedDate: Date?
        var sheduleList = [TravelSchedule]()
        var showAddView = false
    }
    
    enum Action {
        case addButtonTapped
        case dateSelected(Date)
    }
}

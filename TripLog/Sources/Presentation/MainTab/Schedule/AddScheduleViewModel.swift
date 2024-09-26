//
//  AddScheduleViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import Foundation

final class AddScheduleViewModel: ViewModel {
    @Injected private var scheduleRespository: ScheduleRepository
    @Published var state = State()
    
    weak var delegate: CompleteDelegate?
    
    func mutate(action: Action) {
        switch action {
        case .intervalSelected(let interval):
            state.selectedDateInterval = interval
        case .doneButtonTapped:
            addSchedule()
        }
    }
    
    private func addSchedule() {
        do {
            guard let dateInterval = state.selectedDateInterval
            else { throw AddScheduleError.dateNotSelected }
            try scheduleRespository.addSchedule(
                schedule: TravelSchedule(
                    title: state.scheduleTitle,
                    startDate: dateInterval.start,
                    endDate: dateInterval.end
                )
            )
            delegate?.onComplete()
            state.selectedDateInterval = nil
            state.scheduleTitle = ""
            state.isCompleted = true
        } catch {
            dump(error)
        }
    }
    
    enum AddScheduleError: Error {
        case dateNotSelected
    }
}

extension AddScheduleViewModel {
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

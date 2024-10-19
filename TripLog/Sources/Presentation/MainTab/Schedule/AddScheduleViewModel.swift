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
        case .onAppear(let schedule):
            if let schedule {
                replaceSchedule(schedule: schedule)
            }
        case .onDisappear:
            resetSchedule()
        case .dateSelected(let date):
            state.selectedDate = date
        case .intervalSelected(let interval):
            state.selectedDateInterval = interval
        case .doneButtonTapped(let schedule):
            if let schedule {
                updateSchedule(schedule: schedule)
            } else {
                addSchedule()
            }
            taskCompleted()
        case .trashButtonTapped:
            state.showAlert = true
        case .cancelButtonTapped:
            state.showAlert = false
        case .removeButtonTapped(let schedule):
            removeSchedule(schedule: schedule)
            taskCompleted()
        }
    }
    
    private func replaceSchedule(schedule: TravelSchedule) {
        state.scheduleTitle = schedule.title
        state.selectedDateInterval = schedule.dateInterval
    }
    
    private func resetSchedule() {
        state.scheduleTitle = ""
        state.selectedDateInterval = nil
        state.isCompleted = false
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
        } catch {
            dump(error)
        }
    }
    
    private func updateSchedule(schedule: TravelSchedule) {
        do {
            guard let dateInterval = state.selectedDateInterval
            else { throw AddScheduleError.dateNotSelected }
            try scheduleRespository.updateSchedule(
                schedule: TravelSchedule(
                    id: schedule.id,
                    title: state.scheduleTitle,
                    startDate: dateInterval.start,
                    endDate: dateInterval.end
                )
            )
        } catch {
            dump(error)
        }
    }
    
    private func removeSchedule(schedule: TravelSchedule) {
        do {
            try scheduleRespository.removeSchedule(schedule: schedule)
        } catch {
            dump(error)
        }
    }
    
    private func taskCompleted() {
        delegate?.onComplete()
        state.selectedDateInterval = nil
        state.scheduleTitle = ""
        state.isCompleted = true
    }
    
    enum AddScheduleError: Error {
        case dateNotSelected
    }
}

extension AddScheduleViewModel {
    struct State {
        var selectedDate: Date?
        var selectedDateInterval: DateInterval?
        var scheduleTitle = ""
        var isCompleted = false
        var showAlert = false
        
        var statusDescription: String {
            selectedDateInterval == nil ?
            selectedDate == nil ? "일정을 선택해주세요" : "종료일을 선택해주세요" :
            scheduleTitle.isEmpty ? "일정 이름을 입력해주세요" : ""
        }
        var isDoneButtonDisabled: Bool {
            selectedDateInterval == nil || scheduleTitle.isEmpty
        }
    }
    
    enum Action {
        case onAppear(TravelSchedule?)
        case onDisappear
        case dateSelected(Date?)
        case intervalSelected(DateInterval?)
        case doneButtonTapped(TravelSchedule?)
        case trashButtonTapped
        case cancelButtonTapped
        case removeButtonTapped(TravelSchedule)
    }
}

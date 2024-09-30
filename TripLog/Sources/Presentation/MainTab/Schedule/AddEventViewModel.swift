//
//  AddEventViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/24/24.
//

import Foundation

protocol CompleteDelegate: AnyObject {
    func onComplete()
}

final class AddEventViewModel: ViewModel {
    private let scheduleID: String
    
    @Injected private var scheduleRepository: ScheduleRepository
    
    @Published var state = State()
    
    weak var delegate: CompleteDelegate?
    
    init(
        scheduleID: String,
        date: Date
    ) {
        self.scheduleID = scheduleID
        state.selectedDate = date
    }
    
    func mutate(action: Action) {
        switch action {
        case .doneButtonTapped(let event):
            if let event {
                updateEvent(event: event)
            } else {
                addEvent()
            }
            taskCompleted()
        case .trashButtonTapped:
            state.showAlert = true
        case .cancelButtonTapped:
            state.showAlert = false
        case .removeButtonTapped(let event):
            removeEvent(event: event)
            taskCompleted()
        }
    }
    
    private func addEvent() {
        do {
            try scheduleRepository.addEvent(
                scheduleID: scheduleID,
                event: TravelEvent(
                    id: UUID().uuidString,
                    title: state.scheduleTitle,
                    date: state.selectedDate
                )
            )
        } catch {
            dump(error)
        }
    }
    
    private func updateEvent(event: TravelEvent) {
        do {
            try scheduleRepository.updateEvent(
                scheduleID: scheduleID,
                event: TravelEvent(
                    id: event.id,
                    title: state.scheduleTitle,
                    date: state.selectedDate
                )
            )
        } catch {
            dump(error)
        }
    }
    
    private func removeEvent(event: TravelEvent) {
        do {
            try scheduleRepository.removeEvent(
                scheduleID: scheduleID,
                event: event
            )
        } catch {
            dump(error)
        }
    }
    
    private func taskCompleted() {
        delegate?.onComplete()
        state.onDismissed = true
    }
}

extension AddEventViewModel {
    struct State {
        var scheduleTitle = ""
        var selectedDate = Date.now
        var onDismissed = false
        var showAlert = false
        
        var isDoneButtonDisabled: Bool { scheduleTitle.isEmpty }
    }
    
    enum Action {
        case doneButtonTapped(TravelEvent?)
        case trashButtonTapped
        case cancelButtonTapped
        case removeButtonTapped(TravelEvent)
    }
}

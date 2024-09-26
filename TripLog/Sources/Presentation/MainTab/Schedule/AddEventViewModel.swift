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
        case .doneButtonTapped:
            addEvent()
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
            delegate?.onComplete()
            state.onDismissed = true
        } catch {
            dump(error)
        }
    }
}

extension AddEventViewModel {
    struct State {
        var scheduleTitle = ""
        var selectedDate = Date.now
        var onDismissed = false
        
        var isDoneButtonDisabled: Bool { scheduleTitle.isEmpty }
    }
    
    enum Action {
        case doneButtonTapped
    }
}

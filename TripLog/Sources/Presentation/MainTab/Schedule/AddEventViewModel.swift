//
//  AddEventViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/24/24.
//

import Foundation

protocol AddEventViewModelDelegate: AnyObject {
    func addEventCompleted()
}

final class AddEventViewModel: ViewModel {
    private let scheduleID: String
    
    @Injected private var scheduleRepository: ScheduleRepository
    
    @Published var state = State()
    
    weak var delegate: AddEventViewModelDelegate?
    
    init(
        scheduleID: String,
        date: Date
    ) {
        self.scheduleID = scheduleID
        state.selectedDate = date
    }
    
    func mutate(action: Action) {
        Task {
            switch action {
            case .doneButtonTapped:
                try await scheduleRepository.addEvent(
                    scheduleID: scheduleID,
                    event: TravelEvent(
                        title: state.scheduleTitle,
                        date: state.selectedDate
                    )
                )
                delegate?.addEventCompleted()
                await MainActor.run {
                    state.onDismissed = true
                }
            }
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

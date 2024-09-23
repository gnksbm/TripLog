//
//  AddSchduleViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/23/24.
//

import Foundation

final class AddSchduleViewModel: ViewModel {
    @Published var state = State()
    
    func mutate(action: Action) {
        switch action {
        case .doneButtonTapped:
            break
        case .onComplete:
            state.isCompleted = true
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
        case doneButtonTapped
        case onComplete
    }
}

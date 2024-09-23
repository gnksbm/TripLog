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
        case .onComplete:
            state.isCompleted = true
        }
    }
}

extension AddSchduleViewModel {
    struct State {
        var isCompleted = false
    }
    
    enum Action {
        case onComplete
    }
}

//
//  EventListViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

final class EventListViewModel: ViewModel {
    @Injected private var touristRepository: TouristRepository
    
    @Published var state = State()
    
    @MainActor
    func mutate(action: Action) {
        switch action {
        case .onAppear:
            Task {
                state.area = try await touristRepository.fetchAreaCode()
            }
        case .areaSelected(_):
            break
        }
    }
}

extension EventListViewModel {
    struct State {
        var area = [AreaCodeResponse]()
    }
    
    enum Action {
        case onAppear
        case areaSelected(AreaCodeResponse)
    }
}

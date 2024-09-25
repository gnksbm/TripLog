//
//  RecordListViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

final class RecordListViewModel: ViewModel {
    @Injected private var recordRepository: RecordRepository
    
    @Published var state = State()
    
    func mutate(action: Action) {
        switch action {
        case .onAppear:
            Task {
                state.list = try await recordRepository.fetchRecords()
            }
        case .itemTapped(let travelRecord):
            state.detailRecord = travelRecord
        case .detailDismissed:
            state.detailRecord = nil
        }
    }
}

extension RecordListViewModel {
    struct State {
        var list = [TravelRecord]()
        var detailRecord: TravelRecord?
    }
    
    enum Action { 
        case onAppear
        case itemTapped(TravelRecord)
        case detailDismissed
    }
}

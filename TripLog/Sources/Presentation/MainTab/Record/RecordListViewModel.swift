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
            fetchRecords()
        case .itemTapped(let travelRecord):
            state.detailRecord = travelRecord
        case .addButtonTapped:
            state.showAddView = true
        case .detailDismissed:
            state.detailRecord = nil
        }
    }
    
    private func fetchRecords() {
        Task {
            state.list = try await recordRepository.fetchRecords()
        }
    }
}

extension RecordListViewModel {
    struct State {
        var list = [TravelRecord]()
        var detailRecord: TravelRecord?
        var showAddView = false
    }
    
    enum Action { 
        case onAppear
        case itemTapped(TravelRecord)
        case addButtonTapped
        case detailDismissed
    }
}

extension RecordListViewModel: CompleteDelegate {
    func onComplete() {
        fetchRecords()
    }
}

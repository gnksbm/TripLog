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
                do {
                    state.areaList = try await touristRepository.fetchAreaCode()
                } catch {
                    dump(error)
                }
            }
        case .areaSelected(let area):
            Task {
                do {
                    state.festivalList =
                    try await touristRepository.fetchFestival(
                        areaCode: area.areaCode
                    )
                    state.isLoading = false
                } catch {
                    dump(error)
                }
            }
        case .itemTapped(let item):
            state.detailItem = item
            state.showDetail = true
        case .onDismissed:
            state.detailItem = nil
            state.showDetail = false
        }
    }
}

extension EventListViewModel {
    struct State {
        var areaList = [AreaCodeResponse]()
        var festivalList = [SearchFestivalResponse]()
        var showDetail = false
        var detailItem: SearchFestivalResponse?
        var isLoading = true
    }
    
    enum Action {
        case onAppear
        case areaSelected(AreaCodeResponse)
        case itemTapped(SearchFestivalResponse)
        case onDismissed
    }
}

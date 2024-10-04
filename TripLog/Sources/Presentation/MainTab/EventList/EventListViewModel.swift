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
            state.selectedArea = area
            resetPageInfo()
            fetchItems()
        case .itemTapped(let item):
            state.detailItem = item
            state.showDetail = true
        case .onDismissed:
            state.detailItem = nil
            state.showDetail = false
        case .lastItemAppear:
            guard !state.isLoading, !state.isLastPage else { return }
            state.page += 1
            fetchNextItems()
        }
    }
    
    private func fetchItems() {
        Task {
            guard let area = state.selectedArea else { return }
            do {
                await MainActor.run {
                    state.isLoading = true
                }
                let result = try await touristRepository.fetchFestivalWithPage(
                    pageNo: state.page,
                    numOfRows: state.itemPerPage,
                    areaCode: area.areaCode
                )
                await MainActor.run {
                    state.festivalList = result.list
                    state.page = result.page
                    state.isLastPage = state.festivalList.count >= result.total
                    state.isLoading = false
                }
            } catch {
                dump(error)
            }
        }
    }
    
    private func fetchNextItems() {
        Task {
            guard let area = state.selectedArea else { return }
            do {
                await MainActor.run {
                    state.isLoading = true
                }
                let result = try await touristRepository.fetchFestivalWithPage(
                    pageNo: state.page,
                    numOfRows: state.itemPerPage,
                    areaCode: area.areaCode
                )
                await MainActor.run {
                    state.festivalList = state.festivalList + result.list
                    state.page = result.page
                    state.isLastPage = state.festivalList.count >= result.total
                    state.isLoading = false
                }
            } catch {
                dump(error)
            }
        }
    }
    
    private func resetPageInfo() {
        state.page = 0
        state.isLastPage = false
    }
}

extension EventListViewModel {
    struct State {
        var page = 0
        var areaList = [AreaCodeResponse]()
        var selectedArea: AreaCodeResponse?
        var festivalList = [SearchFestivalResponse]()
        var showDetail = false
        var detailItem: SearchFestivalResponse?
        var isLoading = true
        var isLastPage = false
        let itemPerPage = 10
    }
    
    enum Action {
        case onAppear
        case areaSelected(AreaCodeResponse)
        case itemTapped(SearchFestivalResponse)
        case onDismissed
        case lastItemAppear
    }
}

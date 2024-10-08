//
//  EventListView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI

extension AreaCodeResponse: SliderItemType {
    static func == (lhs: AreaCodeResponse, rhs: AreaCodeResponse) -> Bool {
        lhs.areaCode == rhs.areaCode
    }
    
    var id: Int { areaCode }
    var title: String { areaName }
}

extension SearchFestivalResponse: Identifiable {
    var id: String { contentID }
}

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                areaSliderView
                festivalListView
            }
            .background(TLColor.backgroundGray.ignoresSafeArea())
            .navigationDestination(
                isPresented: Binding(
                    get: { viewModel.state.showDetail },
                    set: { isPresented in
                        viewModel.send(action: .onDismissed)
                    }
                )
            ) {
                if let item = viewModel.state.detailItem {
                    LocationDetailView(item: item)
                }
            }
        }
        .overlay {
            if viewModel.state.isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(TLColor.deepBlue)
            }
        }
        .onAppear {
            viewModel.send(action: .onAppear)
        }
    }
    
    var areaSliderView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            SliderView(
                items: viewModel.state.areaList,
                titleColor: TLColor.primaryText,
                fillColor: TLColor.skyBlueLight.opacity(0.2),
                lineColor: TLColor.oceanBlue,
                maxItem: 5,
                barHeight: 4
            ) { item in
                viewModel.mutate(action: .areaSelected(item))
            }
            .padding(.vertical, 12)
        }
    }
    
    var festivalListView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.state.festivalList.withIndex, id: \.1) { index, festival in
                    FestivalCardView(festival: festival)
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            viewModel.send(action: .itemTapped(festival))
                        }
                        .onAppear {
                            if index == viewModel.state.festivalList.count - 1 {
                                viewModel.send(action: .lastItemAppear)
                            }
                        }
                }
            }
        }
        .scrollIndicators(.never)
    }
}

#Preview {
    EventListView()
}

extension Collection {
    var withIndex: Array<(Index, Element)> {
        Array(zip(indices, self))
    }
}

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
            ScrollView(.horizontal) {
                SliderView(items: viewModel.state.areaList) { item in
                    viewModel.mutate(action: .areaSelected(item))
                }
            }
            ScrollView {
                ForEach(viewModel.state.festivalList) { festival in
                }
            }
        }
        .onAppear {
            viewModel.send(action: .onAppear)
        }
    }
}

#Preview {
    EventListView()
}

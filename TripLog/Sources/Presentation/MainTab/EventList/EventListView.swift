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

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    
    var body: some View {
        NavigationStack { 
            ScrollView(.horizontal) {
                SliderView(items: viewModel.state.area) { item in
                    viewModel.mutate(action: .areaSelected(item))
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

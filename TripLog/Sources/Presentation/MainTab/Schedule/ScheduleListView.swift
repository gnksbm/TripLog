//
//  ScheduleListView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI

extension Date: SliderItemType {
    public var id: Date { self }
    var title: String { formatted(dateFormat: .onlyDay) }
}

struct ScheduleListView: View {
    @StateObject private var viewModel = ScheduleListViewModel()
    
    var body: some View {
        NavigationStack { 
            TabView(selection: $viewModel.state.selectedSchdule) {
                ForEach(
                    viewModel.state.sheduleList,
                    id: \.hashValue
                ) { schedule in
                    Text(schedule.title)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.send(action: .addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .tabViewStyle(.page)
            .navigationDestination(isPresented: $viewModel.state.showAddView) {
                AddSchduleView()
            }
            if let selectedSchdule = viewModel.state.selectedSchdule {
                SliderView(
                    items: selectedSchdule.dateInterval.datesInPeriod
                ) { date in
                    viewModel.send(action: .dateSelected(date))
                }
                ScrollView {
                    ForEach(selectedSchdule.events, id: \.hashValue) { event in
                        Text(event.title)
                    }
                }
            }
        }
    }
}

#Preview {
    ScheduleListView()
}

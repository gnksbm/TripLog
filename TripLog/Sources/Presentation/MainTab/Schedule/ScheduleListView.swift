//
//  ScheduleListView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI

extension TravelSchedule: SliderItemType { }

extension Date: SliderItemType {
    public var id: Date { self }
    var title: String { formatted(dateFormat: .onlyDay) }
}

struct ScheduleListView: View {
    @StateObject private var viewModel = ScheduleListViewModel()
    @StateObject private var addScheduleViewModel = AddScheduleViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.state.scheduleList.isEmpty {
                    emptyPlaceholderView
                } else {
                    listView
                }
            }
            .navigationDestination(isPresented: $viewModel.state.showAddView) {
                AddSchduleView()
                    .environmentObject(addScheduleViewModel)
                    .onAppear {
                        addScheduleViewModel.delegate = viewModel
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
        }
        .sheet(item: $viewModel.state.showMapView) {
            viewModel.send(action: .onMapDismissed)
        } content: { event in
            EventMapView(event: event)
        }
        .onAppear {
            viewModel.send(action: .onAppear)
        }
        .onChange(of: viewModel.state.showAddView) { isPresented in
            if !isPresented {
                viewModel.send(action: .onDismissed)
            }
        }
    }
    
    @ViewBuilder
    var listView: some View {
        TabView(selection: $viewModel.state.selectedIndex) {
            ForEach(
                Array(
                    zip(
                        viewModel.state.scheduleList.indices,
                        viewModel.state.scheduleList
                    )
                ),
                id: \.1.hashValue
            ) { index, schedule in
                VStack {
                    Text(schedule.title)
                    ProgressView(
                        timerInterval: schedule.startDate...schedule.endDate
                    )
                    .foregroundStyle(.red)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(TLColor.boxBackground)
                }
                .padding()
                .tag(index)
            }
        }
        .tabViewStyle(.page)
        .navigationDestination(
            isPresented: $viewModel.state.showAddEventView
        ) {
            if let scheduleID = viewModel.state.selectedSchedule?.id,
               let date = viewModel.state.selectedDate {
                AddEventView(
                    scheduleID: scheduleID,
                    date: date,
                    vmDelegate: viewModel
                )
            }
        }
        if let selectedSchdule = viewModel.state.selectedSchedule {
            ScrollView(.horizontal) {
                SliderView(
                    items: selectedSchdule.dateInterval.datesInPeriod
                ) { date in
                    viewModel.send(action: .dateSelected(date))
                }
            }
            .scrollIndicators(.never)
            ScrollView {
                if !viewModel.state.eventList.isEmpty {
                    ForEach(
                        viewModel.state.eventList,
                        id: \.hashValue
                    ) { event in
                        HStack {
                            Group {
                                if event.date.isPast {
                                    Circle()
                                        .fill(.black)
                                } else {
                                    Circle().stroke()
                                }
                            }
                            .frame(width: 10, height: 10)
                            HStack {
                                Text(
                                    event.date.formatted(dateFormat: .onlyTime)
                                )
                                Text(event.title)
                                Spacer()
                                if event.locationInfo != nil {
                                    Button {
                                        viewModel.send(
                                            action: .mapButtonTapped(event)
                                        )
                                    } label: {
                                        Image(systemName: "map")
                                    }
                                }
                            }
                            .padding()
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke()
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                } else {
                    Text("등록된 일정이 없어요")
                        .padding()
                }
                Button {
                    viewModel.send(action: .addEventButtonTapped)
                } label: {
                    Label("일정 추가하기", systemImage: "plus")
                }
            }
        } else {
            Spacer()
        }
        
    }
    
    var emptyPlaceholderView: some View {
        Text("등록한 일정이 없어요")
    }
}

#if DEBUG
#Preview {
    DIContainer.register(
        MockScheduleRepository(),
        type: ScheduleRepository.self
    )
    return ScheduleListView()
}
#endif

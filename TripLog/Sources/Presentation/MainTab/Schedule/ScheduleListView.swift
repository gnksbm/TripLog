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

extension TravelEvent: Identifiable {
    var id: Self { self }
}

struct ScheduleListView: View {
    @StateObject private var viewModel = ScheduleListViewModel()
    
    var body: some View {
        NavigationStack {
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
                    Text(schedule.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke()
                        }
                        .padding()
                        .tag(index)
                }
            }
            .frame(height: 200)
            .tabViewStyle(.page)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.send(action: .addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
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
            .navigationDestination(isPresented: $viewModel.state.showAddView) {
                AddSchduleView()
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
                        Button {
                            viewModel.send(action: .addEventButtonTapped)
                        } label: {
                            Label("일정 추가하기", systemImage: "plus")
                        }
                    }
                }
            } else {
                Spacer()
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

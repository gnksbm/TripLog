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
                AddScheduleView()
                    .environmentObject(addScheduleViewModel)
                    .onAppear {
                        addScheduleViewModel.delegate = viewModel
                    }
            }
            .navigationDestination(isPresented: $viewModel.state.showAddEventView) {
                if let scheduleID = viewModel.state.selectedSchedule?.id,
                   let date = viewModel.state.selectedDate {
                    AddEventView(
                        scheduleID: scheduleID,
                        date: date,
                        vmDelegate: viewModel
                    )
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.send(action: .addButtonTapped)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(TLColor.coralOrange)
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
        .onChange(of: viewModel.state.selectedSchedule) { schedule in
            if let date = schedule?.startDate {
                viewModel.send(action: .dateSelected(date))
            }
        }
        .onChange(of: viewModel.state.showAddView) { isPresented in
            if !isPresented {
                viewModel.send(action: .onDismissed)
            }
        }
    }
    
    var listView: some View {
        VStack(spacing: 16) {
            scheduleCard
            if let selectedSchedule = viewModel.state.selectedSchedule {
                DatePickerView(
                    selectedDate: Binding(
                        get: { viewModel.state.selectedDate },
                        set: { date in
                            if let date {
                                viewModel.send(action: .dateSelected(date))
                            }
                        }
                    ) ,
                    dates: selectedSchedule.dateInterval.datesInPeriod
                )
                .padding(.vertical)
                
                ScrollView {
                    if !viewModel.state.eventList.isEmpty {
                        ForEach(viewModel.state.eventList, id: \.hashValue) { event in
                            HStack {
                                if event.date.isToday {
                                    if event.date.isPast {
                                        Circle()
                                            .fill(TLColor.coralOrange)
                                            .frame(width: 10, height: 10)
                                    } else {
                                        Circle()
                                            .stroke(TLColor.coralOrange, lineWidth: 2)
                                            .frame(width: 10, height: 10)
                                    }
                                } else {
                                    Circle()
                                        .fill(TLColor.separatorGray)
                                        .frame(width: 10, height: 10)
                                }
                                VStack(alignment: .leading) {
                                    Text(event.date.formatted(dateFormat: .onlyTime))
                                        .font(TLFont.caption)
                                        .foregroundColor(TLColor.secondaryText)
                                    Text(event.title)
                                        .font(TLFont.body)
                                        .fontWeight(.semibold)
                                        .foregroundColor(TLColor.primaryText)
                                }
                                
                                Spacer()

                                if event.locationInfo != nil {
                                    Button {
                                        viewModel.send(action: .mapButtonTapped(event))
                                    } label: {
                                        Image(systemName: "map.fill")
                                            .foregroundColor(TLColor.royalBlue)
                                    }
                                }
                            }
                            .padding()
                            .background {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3))
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        Image(systemName: "calendar.badge.plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(TLColor.secondaryText)
                            .padding(.top, 16)
                        Text("등록된 일정이 없어요")
                            .font(TLFont.body)
                            .foregroundColor(TLColor.secondaryText)
                            .padding()
                    }
                    
                    Button {
                        viewModel.send(action: .addEventButtonTapped)
                    } label: {
                        Label("일정 추가하기", systemImage: "plus")
                            .font(TLFont.body)
                            .foregroundColor(.white)
                            .padding()
                            .background(Capsule().fill(TLColor.coralOrange))
                    }
                    .padding()
                }
            }
        }
    }
    
    var scheduleCard: some View {
        TabView(selection: $viewModel.state.selectedIndex) {
            ForEach(
                Array(zip(viewModel.state.scheduleList.indices, viewModel.state.scheduleList)),
                id: \.1.hashValue
            ) { index, schedule in
                eventCard(schedule: schedule)
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(height: 200)
        .background(TLColor.backgroundGray)
    }
    
    var emptyPlaceholderView: some View {
        VStack {
            Image(systemName: "calendar.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(TLColor.secondaryText)
                .padding(.bottom, 16)
            
            Text("등록된 일정이 없어요")
                .font(TLFont.headline)
                .foregroundColor(TLColor.secondaryText)
            
            Text("새로운 일정을 추가해보세요")
                .font(TLFont.caption)
                .foregroundColor(TLColor.secondaryText)
                .padding(.top, 4)
            
            Button {
                viewModel.send(action: .addButtonTapped)
            } label: {
                Label("일정 추가하기", systemImage: "plus")
                    .font(TLFont.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Capsule().fill(TLColor.coralOrange))
            }
            .padding(.top, 24)
        }
        .padding()
    }
    
    func eventCard(schedule: TravelSchedule) -> some View {
        VStack(spacing: 40) {
            HStack {
                Text(schedule.title)
                    .font(TLFont.headline)
                    .bold()
                    .foregroundColor(TLColor.primaryText)
                Spacer()
                Label("남은 일정", systemImage: "checklist")
                Text(schedule.eventStr)
            }
            ProgressView(value: schedule.dateInterval.periodProgress) {
                HStack {
                    Text(
                        schedule.startDate.formatted(dateFormat: .monthAndDateDot) +
                        " ~ " +
                        schedule.endDate.formatted(dateFormat: .monthAndDateDot)
                    )
                    Spacer()
                    Text(schedule.dateInterval.distanceFromToday)
                }
            }
            .progressViewStyle(LinearProgressViewStyle(tint: TLColor.coralOrange))
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(TLColor.lightPeach.opacity(0.4))
                .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
        }
        .padding(.horizontal)
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

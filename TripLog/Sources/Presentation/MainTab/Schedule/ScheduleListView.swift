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
        .onChange(of: viewModel.state.showAddView) { isPresented in
            if !isPresented {
                viewModel.send(action: .onDismissed)
            }
        }
    }
    
    @ViewBuilder
    var listView: some View {
        VStack {
            TabView(selection: $viewModel.state.selectedIndex) {
                ForEach(
                    Array(zip(viewModel.state.scheduleList.indices, viewModel.state.scheduleList)),
                    id: \.1.hashValue
                ) { index, schedule in
                    VStack {
                        Text(schedule.title)
                            .font(TLFont.headline)
                            .foregroundColor(TLColor.primaryText)
                            .padding(.bottom, 8)
                        
                        ProgressView(timerInterval: schedule.startDate...schedule.endDate)
                            .progressViewStyle(LinearProgressViewStyle(tint: TLColor.coralOrange))
                            .padding(.bottom, 16)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(TLColor.lightPeach.opacity(0.4))
                            .shadow(color: .gray.opacity(0.2), radius: 6, x: 0, y: 4)
                    }
                    .padding(.horizontal)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: 300)

            if let selectedSchedule = viewModel.state.selectedSchedule {
                ScrollView(.horizontal) {
                    SliderView(
                        items: selectedSchedule.dateInterval.datesInPeriod
                    ) { date in
                        viewModel.send(action: .dateSelected(date))
                    }
                }
                .scrollIndicators(.never)
                
                ScrollView {
                    if !viewModel.state.eventList.isEmpty {
                        ForEach(viewModel.state.eventList, id: \.hashValue) { event in
                            HStack {
                                Group {
                                    if event.date.isPast {
                                        Circle().fill(Color.gray)
                                    } else {
                                        Circle().stroke(TLColor.coralOrange, lineWidth: 2)
                                    }
                                }
                                .frame(width: 10, height: 10)

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
            } else {
                Spacer()
            }
        }
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

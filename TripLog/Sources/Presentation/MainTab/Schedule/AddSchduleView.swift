//
//  AddSchduleView.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import SwiftUI

struct AddScheduleView: View {
    @EnvironmentObject private var viewModel: AddScheduleViewModel
    @StateObject private var calendarViewModel = CalendarViewModel(selectType: .period)
    @Environment(\.dismiss) private var dismiss
    var selectedSchedule: TravelSchedule?
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 40) {
                    dateView(proxy: proxy)
                        .id(AddContent.date)
                    titleView(proxy: proxy)
                        .id(AddContent.title)
                    doneButton(proxy: proxy)
                        .id(AddContent.done)
                }
                .padding(.horizontal, 24)
                .padding(.top, 30)
                .background(TLColor.backgroundGray.ignoresSafeArea())
                .onChange(of: calendarViewModel.state.selectedDate) { date in
                    viewModel.send(action: .dateSelected(date))
                }
                .onChange(of: calendarViewModel.state.selectedDateInterval) { interval in
                    viewModel.send(action: .intervalSelected(interval))
                    if interval != nil {
                        withAnimation {
                            proxy.scrollTo(AddContent.title, anchor: .top)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let selectedSchedule {
                    Button {
                        viewModel.send(action: .trashButtonTapped)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .foregroundStyle(TLColor.errorRed)
                            .alert("일정을 삭제하시겠습니까?", isPresented: $viewModel.state.showAlert) {
                                Button("삭제", role: .destructive) {
                                    viewModel.send(action: .removeButtonTapped(selectedSchedule))
                                }
                                Button("취소", role: .cancel) {
                                    viewModel.send(action: .cancelButtonTapped)
                                }          
                            } message: {
                                Text("일정에 등록된 세부일정들이 모두 삭제됩니다")
                            }
                    }
                }
            }
        }
        .navigationTitle(selectedSchedule == nil ? "일정 등록" : "일정 수정")
        .navigationBarTitleDisplayMode(.inline)
        .background(TLColor.backgroundGray.ignoresSafeArea())
        .onChange(of: viewModel.state.isCompleted) { _ in
            dismiss()
        }
        .onAppear {
            viewModel.send(action: .onAppear(selectedSchedule))
            calendarViewModel.state.selectedDateInterval =
            selectedSchedule?.dateInterval
        }
        .onDisappear {
            viewModel.send(action: .onDisappear)
            calendarViewModel.state.selectedDateInterval = nil
        }
    }
    
    func dateView(proxy: ScrollViewProxy) -> some View {
        InputSectionView(title: "날짜") {
            CalendarView(viewModel: calendarViewModel)
        }
    }
        
    func titleView(proxy: ScrollViewProxy) -> some View {
        InputSectionView(title: "이름") {
            TextField("일정 이름을 입력하세요", text: $viewModel.state.scheduleTitle)
                .textFieldStyle(PlainTextFieldStyle())
                .onSubmit {
                    proxy.scrollTo(AddContent.done, anchor: .bottom)
                }
        }
    }
       
    func doneButton(proxy: ScrollViewProxy) -> some View {
        VStack {
            Text(viewModel.state.statusDescription)
                .font(TLFont.caption)
                .fontWeight(.black)
                .foregroundStyle(
                    viewModel.state.statusDescription.isEmpty ?
                    TLColor.successGreen : TLColor.errorRed
                )
                .padding(.bottom)
            Button {
                viewModel.send(action: .doneButtonTapped(selectedSchedule))
            } label: {
                Text("완료")
                    .font(TLFont.body)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(viewModel.state.isDoneButtonDisabled ? TLColor.separatorGray : TLColor.oceanBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .disabled(viewModel.state.isDoneButtonDisabled)
        }
        .padding(.top, 40)
    }
    
    init(schedule: TravelSchedule? = nil) {
        selectedSchedule = schedule
    }
    
    enum AddContent {
        case date, title, done
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        AddScheduleView()
            .environmentObject(AddScheduleViewModel())
    }
}
#endif

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
                    .padding(.top, 40)
                    .id(AddContent.done)
                }
                .padding(.horizontal, 24)
                .padding(.top, 30)
                .background(TLColor.backgroundGray.ignoresSafeArea())
                .onChange(of: calendarViewModel.state.selectedDateInterval) { interval in
                    guard let interval else { return }
                    viewModel.send(action: .intervalSelected(interval))
                    withAnimation {
                        proxy.scrollTo(AddContent.title, anchor: .top)
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
            if let selectedSchedule {
                viewModel.state.scheduleTitle = selectedSchedule.title
                viewModel.state.selectedDateInterval = selectedSchedule.dateInterval
                calendarViewModel.state.selectedDateInterval = selectedSchedule.dateInterval
            }
        }
    }
    
    func dateView(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("날짜")
                .font(TLFont.headline)
                .fontWeight(.black)
                .foregroundColor(TLColor.primaryText)
            
            CalendarView(viewModel: calendarViewModel)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.skyBlueLight.opacity(0.4)))
        }
    }
        
    @ViewBuilder
    func titleView(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("이름")
                .font(TLFont.headline)
                .fontWeight(.black)
                .foregroundColor(TLColor.primaryText)
            
            TextField("일정 이름을 입력하세요", text: $viewModel.state.scheduleTitle)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.skyBlueLight.opacity(0.2)))
                .onSubmit {
                    proxy.scrollTo(AddContent.done, anchor: .bottom)
                }
        }
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
    DIContainer.register(
        MockScheduleRepository(),
        type: ScheduleRepository.self
    )
    return NavigationStack {
        AddScheduleView()
    }
}
#endif

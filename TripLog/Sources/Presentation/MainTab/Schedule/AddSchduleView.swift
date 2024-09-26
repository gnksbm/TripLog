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
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack(spacing: 50) {
                    dateView(proxy: proxy)
                        .id(AddContent.date)
                    
                    titleView(proxy: proxy)
                        .id(AddContent.title)
                    
                    Button {
                        viewModel.send(action: .doneButtonTapped)
                    } label: {
                        Text("완료")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.state.isDoneButtonDisabled ? Color.gray : Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .disabled(viewModel.state.isDoneButtonDisabled)
                    .padding(.top, 40)
                    .id(AddContent.done)
                }
                .padding(.horizontal)
                .padding(.top, 20)
                .onChange(of: calendarViewModel.state.selectedDateInterval) { interval in
                    guard let interval else { return }
                    viewModel.send(action: .intervalSelected(interval))
                    withAnimation {
                        proxy.scrollTo(AddContent.title, anchor: .top)
                    }
                }
            }
        }
        .navigationTitle("일정 등록")
        .onChange(of: viewModel.state.isCompleted) { _ in
            dismiss()
        }
    }
    
    // 날짜 선택 뷰
    func dateView(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("날짜")
                .font(.title)
                .bold()
            
            CalendarView(viewModel: calendarViewModel)
        }
    }
        
    // 일정 이름 입력 뷰
    @ViewBuilder
    func titleView(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("이름")
                .font(.title)
                .bold()
            
            TextField("일정 이름을 입력하세요", text: $viewModel.state.scheduleTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    proxy.scrollTo(AddContent.done, anchor: .bottom)
                }
        }
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

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
                VStack(spacing: 40) {
                    dateView(proxy: proxy)
                        .id(AddContent.date)
                    
                    titleView(proxy: proxy)
                        .id(AddContent.title)
                    
                    Button {
                        viewModel.send(action: .doneButtonTapped)
                    } label: {
                        Text("완료")
                            .font(TLFont.body)
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(viewModel.state.isDoneButtonDisabled ? TLColor.separatorGray : TLColor.coralOrange)
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
        .navigationTitle("일정 등록")
        .navigationBarTitleDisplayMode(.inline)
        .background(TLColor.backgroundGray.ignoresSafeArea())
        .onChange(of: viewModel.state.isCompleted) { _ in
            dismiss()
        }
    }
    
    func dateView(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("날짜")
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            CalendarView(viewModel: calendarViewModel)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.lightPeach.opacity(0.4)))
        }
    }
        
    @ViewBuilder
    func titleView(proxy: ScrollViewProxy) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("이름")
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            TextField("일정 이름을 입력하세요", text: $viewModel.state.scheduleTitle)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.lightPeach.opacity(0.2)))
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

//
//  AddSchduleView.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import SwiftUI

struct AddSchduleView: View {
    @StateObject private var viewModel = AddSchduleViewModel()
    @StateObject private var calendarViewModel = CalendarViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                VStack {
                    dateView(proxy: proxy)
                        .id(AddContent.date)
                    Spacer()
                        .frame(height: 100)
                    titleView(proxy: proxy)
                        .id(AddContent.title)
                    Spacer()
                        .frame(height: 100)
                    Button("완료") { 
                        viewModel.send(action: .doneButtonTapped)
                    }
                    .disabled(viewModel.state.isDoneButtonDisabled)
                    .buttonStyle(LargeButtonStyle())
                    .id(AddContent.done)
                }
                .padding()
                .onChange(
                    of: calendarViewModel.state.selectedDateInterval
                ) { interval in
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
    
    func dateView(proxy: ScrollViewProxy) -> some View {
        VStack {
            HStack {
                Text("날짜")
                    .font(.title)
                    .bold()
                Spacer()
            }
            CalendarView(viewModel: calendarViewModel)
        }
    }
        
    @ViewBuilder
    func titleView(proxy: ScrollViewProxy) -> some View {
        VStack {
            HStack {
                Text("이름")
                    .font(.title)
                    .bold()
                Spacer()
            }
            TextField("", text: $viewModel.state.scheduleTitle)
                .textFieldStyle(.roundedBorder)
                .onSubmit {
                    proxy.scrollTo(AddContent.done, anchor: .bottom)
                }
        }
    }
    
    enum AddContent {
        case date, title, done
    }
}

#Preview {
    DIContainer.register(
        MockScheduleRepository(),
        type: ScheduleRepository.self
    )
    return NavigationStack {
        AddSchduleView()
    }
}

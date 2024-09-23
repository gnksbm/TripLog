//
//  CalendarView.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import SwiftUI

struct CalendarView: View {
    @Binding var isCompleted: Bool
    let action: (DateInterval?) -> Void
    
    @StateObject private var viewModel = CalendarViewModel()
    
    private let columns = Array(repeating: GridItem(), count: 7)
    
    var body: some View {
        VStack {
            HStack {
                Button("\(viewModel.state.currentMonth - 1)") {
                    viewModel.send(action: .showPreviousMonth)
                }
                Spacer()
                Text("\(viewModel.state.currentMonth)")
                    .font(.title)
                Spacer()
                Button("\(viewModel.state.currentMonth + 1)") {
                    viewModel.send(action: .showNextMonth)
                }
            }
            .foregroundStyle(.black)
            .font(.title3)
            .bold()
            .padding()
            LazyVGrid(columns: columns) {
                ForEach(viewModel.state.showingDates) { date in
                    let isContainedMonth =
                    date.isSameMonth(viewModel.state.currentMonth)
                    Button {
                        viewModel.send(action: .dateSelected(date))
                    } label: {
                        ZStack {
                            circleFill(date: date)
                            Text(date.formatted(dateFormat: .onlyDay))
                                .padding(.vertical)
                                .foregroundStyle(
                                    isContainedMonth ? .black : .gray
                                )
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.send(action: .onAppear)
        }
        .onChange(of: isCompleted) { _ in
            viewModel.send(action: .onComplete(action))
        }
    }
    
    @ViewBuilder
    func circleFill(date: Date) -> some View {
        if viewModel.state.selectedDate == date {
            Circle()
                .fill(.blue)
        } else if viewModel.state.selectedDateInterval?.start == date {
            Circle()
                .fill(.red)
        } else if viewModel.state.selectedDateInterval?.end == date {
            Circle()
                .fill(.yellow)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    CalendarView(isCompleted: .constant(false)) { interval in }
}

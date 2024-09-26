//
//  CalendarView.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel: CalendarViewModel
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(spacing: 16) {
            // 상단 월 선택 버튼
            HStack {
                Button(action: {
                    viewModel.send(action: .showPreviousMonth)
                }) {
                    Image(systemName: "chevron.left")
                        .padding(.horizontal)
                }
                Spacer()
                Text("\(viewModel.state.currentMonth)")
                    .font(.title)
                    .bold()
                Spacer()
                Button(action: {
                    viewModel.send(action: .showNextMonth)
                }) {
                    Image(systemName: "chevron.right")
                        .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            
            // 날짜 그리드
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.state.showingDates, id: \.self) { date in
                    let isCurrentMonth = date.isSameMonth(viewModel.state.currentMonth)
                    
                    Button(action: {
                        viewModel.send(action: .dateSelected(date))
                    }) {
                        ZStack {
                            circleFill(date: date)
                            Text(date.formatted(dateFormat: .onlyDay))
                                .foregroundColor(isCurrentMonth ? .black : .gray)
                        }
                        .frame(width: 40, height: 40)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.send(action: .onAppear)
        }
    }
    
    // 원형 배경 그리기
    @ViewBuilder
    func circleFill(date: Date) -> some View {
        if viewModel.state.selectedDate == date {
            Circle()
                .fill(Color.blue)
                .frame(width: 40, height: 40)
        } else if viewModel.state.selectedDateInterval?.start == date {
            Circle()
                .fill(Color.red)
                .frame(width: 40, height: 40)
        } else if viewModel.state.selectedDateInterval?.end == date {
            Circle()
                .fill(Color.yellow)
                .frame(width: 40, height: 40)
        } else {
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    CalendarView(viewModel: CalendarViewModel())
}

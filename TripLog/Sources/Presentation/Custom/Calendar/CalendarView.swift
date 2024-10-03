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
            HStack {
                Button {
                    viewModel.send(action: .showPreviousMonth)
                } label: {
                    Image(systemName: "chevron.left")
                        .padding(.horizontal)
                }
                .tint(TLColor.oceanBlue)
                Spacer()
                Text("\(viewModel.state.currentMonth)")
                    .font(.title)
                    .bold()
                Spacer()
                Button {
                    viewModel.send(action: .showNextMonth)
                } label: {
                    Image(systemName: "chevron.right")
                        .padding(.horizontal)
                }
                .tint(TLColor.oceanBlue)
            }
            .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.state.showingDates, id: \.self) { date in
                    let isCurrentMonth = date.isSameMonth(viewModel.state.currentMonth)
                    let isSelectedDay = 
                    viewModel.state.selectedDateInterval?.isContained(date: date) == true
                    Button {
                        withAnimation {
                            viewModel.send(action: .dateSelected(date))
                        }
                    } label: {
                        ZStack {
                            circleFill(date: date)
                            Text(date.formatted(dateFormat: .onlyDay))
                                .foregroundColor(
                                    isSelectedDay ?
                                    TLColor.deepBlue :
                                        isCurrentMonth ? .black : .gray
                                )
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
    
    @ViewBuilder
    func circleFill(date: Date) -> some View {
        if viewModel.state.selectedDate == date {
            Circle()
                .fill(TLColor.separatorGray)
                .frame(width: 40, height: 40)
        } else if viewModel.state.selectedDateInterval?.start == date {
            Circle()
                .fill(TLColor.oceanBlueLight.opacity(0.4))
                .frame(width: 40, height: 40)
        } else if viewModel.state.selectedDateInterval?.end == date {
            Circle()
                .fill(TLColor.oceanBlueLight.opacity(0.4))
                .frame(width: 40, height: 40)
        } else {
            Circle()
                .fill(Color.clear)
                .frame(width: 40, height: 40)
        }
    }
}

#Preview {
    CalendarView(viewModel: CalendarViewModel(selectType: .period))
}

#Preview {
    CalendarView(viewModel: CalendarViewModel())
}

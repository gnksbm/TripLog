//
//  CalendarViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/22/24.
//

import Foundation

final class CalendarViewModel: ViewModel {
    @Published var state = State()
    
    func mutate(action: Action) {
        switch action {
        case .onAppear:
            updateShowingDates()
        case .dateSelected(let selectedDate):
            if state.selectedDateInterval != nil {
                state.selectedDateInterval = nil
            }
            if let previousSelectedDate = state.selectedDate {
                if state.selectedDate != selectedDate {
                    state.selectedDateInterval = DateInterval(
                        first: previousSelectedDate,
                        second: selectedDate
                    )
                }
                state.selectedDate = nil
            } else {
                state.selectedDate = selectedDate
            }
        case .showPreviousMonth:
            showPreviousMonth()
        case .showNextMonth:
            showNextMonth()
        case .onComplete(let block):
            block(state.selectedDateInterval)
            state.selectedDateInterval = nil
        }
    }
    
    private func updateShowingDates() {
        var dates = Date.getDatesInMonth(
            offset: state.selectedMonthIndex
        )
        if let firstDate = dates.first {
            let calendar = Calendar.autoupdatingCurrent
            let distanceFromFirstWeek = calendar.component(
                .weekday,
                from: firstDate
            )
            (1...distanceFromFirstWeek).forEach { offset in
                if let emptyDate = calendar.date(
                    byAdding: .day,
                    value: -offset,
                    to: firstDate
                ) {
                    dates.insert(emptyDate, at: 0)
                }
            }
        }
        if let lastDate = dates.last {
            let calendar = Calendar.autoupdatingCurrent
            let distanceFromFirstWeek = calendar.component(
                .weekday,
                from: lastDate
            )
            (1...6 - distanceFromFirstWeek % 7).forEach { offset in
                if let emptyDate = calendar.date(
                    byAdding: .day,
                    value: offset,
                    to: lastDate
                ) {
                    dates.append(emptyDate)
                }
            }
        }
        state.showingDates = dates
    }
    
    private func showPreviousMonth() {
        state.selectedMonthIndex -= 1
        updateShowingDates()
    }
    
    private func showNextMonth() {
        state.selectedMonthIndex += 1
        updateShowingDates()
    }
}

extension CalendarViewModel {
    struct State {
        var selectedDate: Date?
        var selectedDateInterval: DateInterval?
        var selectedMonthIndex = 0
        var showingDates = [Date]()
        
        var currentMonth: Int { Date.getMonth(offset: selectedMonthIndex) }
    }
    
    enum Action {
        case onAppear
        case dateSelected(Date)
        case showPreviousMonth
        case showNextMonth
        case onComplete((DateInterval?) -> Void)
    }
}

#if DEBUG
import SwiftUI
#Preview {
    CalendarView(isCompleted: .constant(false)) { interval in }
}
#endif

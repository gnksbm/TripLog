//
//  DatePickerView.swift
//  TripLog
//
//  Created by gnksbm on 9/27/24.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var selectedDate: Date?
    let dates: [Date]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(dates, id: \.self) { date in
                    VStack {
                        Text(date.formatted(dateFormat: .onlyDay) + "일")
                            .font(.headline)
                            .foregroundColor(dateColor(for: date))
                    }
                    .padding()
                    .background(selectedDate == date ? TLColor.coralOrange : TLColor.lightPeach.opacity(0.4))
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    private func dateColor(for date: Date) -> Color {
        return selectedDate == date ? .white : TLColor.primaryText
    }
}

#Preview {
    DatePickerView(selectedDate: .constant(.now), dates: [.now])
}

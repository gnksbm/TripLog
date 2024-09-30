//
//  AddEventView.swift
//  TripLog
//
//  Created by gnksbm on 9/24/24.
//

import SwiftUI

struct AddEventView: View {
    @StateObject private var viewModel: AddEventViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 30) {
            titleView
            timeView
            Spacer()
            Button("완료") {
                viewModel.send(action: .doneButtonTapped)
            }
            .disabled(viewModel.state.isDoneButtonDisabled)
            .buttonStyle(LargeButtonStyle())
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .background(TLColor.backgroundGray.ignoresSafeArea())
        .navigationTitle("일정 등록")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.state.onDismissed) { value in
            if value {
                dismiss()
            }
        }
    }
    
    var titleView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("일정 이름")
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            TextField("일정 이름을 입력하세요", text: $viewModel.state.scheduleTitle)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.skyBlueLight.opacity(0.2)))
                .textFieldStyle(PlainTextFieldStyle())
        }
    }
    
    var timeView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("시간")
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            DatePicker(
                "시간 선택",
                selection: $viewModel.state.selectedDate,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.skyBlueLight.opacity(0.2)))
        }
    }
    
    init(
        scheduleID: String,
        date: Date,
        vmDelegate: CompleteDelegate? = nil
    ) {
        let viewModel = AddEventViewModel(
            scheduleID: scheduleID,
            date: date
        )
        viewModel.delegate = vmDelegate
        self._viewModel = StateObject(
            wrappedValue: viewModel
        )
    }
}

#Preview {
    AddEventView(scheduleID: "", date: .now)
}

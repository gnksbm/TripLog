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
        VStack {
            titleView
            Spacer()
                .frame(height: 100)
            timeView
            Spacer()
            Button("완료") {
                viewModel.send(action: .doneButtonTapped)
            }
            .disabled(viewModel.state.isDoneButtonDisabled)
            .buttonStyle(LargeButtonStyle())
        }
        .padding()
        .navigationTitle("일정 등록")
        .onChange(of: viewModel.state.onDismissed) { value in
            if value {
                dismiss()
            }
        }
    }
    
    var titleView: some View {
        VStack {
            HStack {
                Text("일정 이름")
                    .font(.title)
                    .bold()
                Spacer()
            }
            TextField("", text: $viewModel.state.scheduleTitle)
                .textFieldStyle(.roundedBorder)
        }
    }
    
    var timeView: some View {
        VStack {
            HStack {
                Text("시간")
                    .font(.title)
                    .bold()
                Spacer()
            }
            DatePicker(
                "",
                selection: $viewModel.state.selectedDate,
                displayedComponents: .hourAndMinute
            )
        }
    }
    
    init(
        scheduleID: String,
        date: Date,
        vmDelegate: CompleteDelegate? = nil
    ) { 
        self._viewModel = StateObject(
            wrappedValue: AddEventViewModel(
                scheduleID: scheduleID,
                date: date
            )
        )
        viewModel.delegate = vmDelegate
    }
}

#Preview {
    AddEventView(scheduleID: "", date: .now)
}

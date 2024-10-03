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
    
    private var selectedEvnet: TravelEvent?
    
    var body: some View {
        VStack(spacing: 30) {
            titleView
            timeView
            Spacer()
            Button("완료") {
                viewModel.send(action: .doneButtonTapped(selectedEvnet))
            }
            .disabled(viewModel.state.isDoneButtonDisabled)
            .buttonStyle(LargeButtonStyle())
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 40)
        .background(TLColor.backgroundGray.ignoresSafeArea())
        .navigationTitle(
            selectedEvnet == nil ? "일정 등록" : "일정 수정"
        )
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if let selectedEvnet {
                    Button {
                        viewModel.send(action: .trashButtonTapped)
                    } label: {
                        Image(systemName: "trash.circle.fill")
                            .foregroundStyle(TLColor.errorRed)
                            .alert("일정을 삭제하시겠습니까?", isPresented: $viewModel.state.showAlert) {
                                Button("삭제", role: .destructive) {
                                    viewModel.send(action: .removeButtonTapped(selectedEvnet))
                                }
                                Button("취소", role: .cancel) {
                                    viewModel.send(action: .cancelButtonTapped)
                                }
                            } message: {
                                Text("삭제된 일정은 복구할 수 없습니다")
                            }
                    }
                }
            }
        }

        .onChange(of: viewModel.state.onDismissed) { value in
            if value {
                dismiss()
            }
        }
        .onAppear {
            if let selectedEvnet {
                viewModel.state.scheduleTitle = selectedEvnet.title
                viewModel.state.selectedDate = selectedEvnet.date
            }
        }
    }
    
    var titleView: some View {
        InputSectionView(title: "일정 이름") {
            TextField(
                "일정 이름을 입력하세요",
                text: $viewModel.state.scheduleTitle
            )
            .textFieldStyle(PlainTextFieldStyle())
        }
    }
    
    var timeView: some View {
        InputSectionView(title: "시간") {
            DatePicker(
                "시간 선택",
                selection: $viewModel.state.selectedDate,
                displayedComponents: .hourAndMinute
            )
            .labelsHidden()
            .datePickerStyle(WheelDatePickerStyle())
        }
    }
    
    init(
        scheduleID: String,
        date: Date,
        selectedEvent: TravelEvent? = nil,
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
        self.selectedEvnet = selectedEvent
    }
}

#Preview {
    AddEventView(scheduleID: "", date: .now)
}

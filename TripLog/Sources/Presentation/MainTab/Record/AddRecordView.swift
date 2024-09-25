//
//  AddRecordView.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import SwiftUI
import PhotosUI

struct AddRecordView: View {
    @StateObject private var viewModel: AddRecordViewModel
    @StateObject private var calendarViewModel = CalendarViewModel()
    @State private var selectedItem = [PhotosPickerItem]()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            dateView
            Spacer(minLength: 100)
            imageSelectionView
            Spacer(minLength: 100)
            contentView
            Spacer(minLength: 100)
            Button("완료") {
                if let date = calendarViewModel.state.selectedDate {
                    viewModel.send(action: .doneButtonTapped(date))
                }
            }
            .disabled(
                viewModel.state.content.isEmpty &&
                calendarViewModel.state.selectedDate != nil
            )
            .buttonStyle(LargeButtonStyle())
        }
        .onChange(of: selectedItem) { items in
            handleItem(items: items)
        }
        .onChange(of: viewModel.state.onCompleted) { _ in
            dismiss()
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        HStack {
            Text("내용")
                .font(.title)
                .bold()
            Spacer()
        }
        TextField("", text: $viewModel.state.content)
            .textFieldStyle(.roundedBorder)
    }
    
    @ViewBuilder
    var imageSelectionView: some View {
        HStack {
            Text("사진")
                .font(.title)
                .bold()
            Spacer()
        }
        ScrollView(.horizontal) {
            HStack {
                ForEach(viewModel.state.selectedImage, id: \.self) { data in
                    if let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .scaledToFill()
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                    }
                }
                PhotosPicker(selection: $selectedItem) {
                    Image(systemName: "plus")
                        .foregroundStyle(.white)
                        .font(.title)
                        .bold()
                }
                .frame(width: 100, height: 100)
                .background(.quaternary)
                .clipShape(
                    RoundedRectangle(cornerRadius: 16)
                )
            }
        }
    }
    
    @ViewBuilder
    var dateView: some View {
        HStack {
            Text("날짜")
                .font(.title)
                .bold()
            Spacer()
        }
        CalendarView(viewModel: calendarViewModel)
    }
    
    private func handleItem(items: [PhotosPickerItem]) {
        let group = DispatchGroup()
        var datas = [Data]()
        items.forEach { item in
            group.enter()
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data {
                        datas.append(data)
                    } else {
                        print(#function, "Data is nil")
                    }
                case .failure(let error):
                    dump(error)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            viewModel.send(action: .imageSeledted(datas))
        }
    }
    
    init(viewModel: AddRecordViewModel = AddRecordViewModel()) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
}

#Preview {
    NavigationStack {
        AddRecordView()
    }
}

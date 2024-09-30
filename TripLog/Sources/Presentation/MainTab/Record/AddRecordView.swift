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
            VStack(spacing: 40) {
                dateView
                imageSelectionView
                contentView
                Button("완료") {
                    if let date = calendarViewModel.state.selectedDate {
                        viewModel.send(action: .doneButtonTapped(date))
                    }
                }
                .disabled(
                    viewModel.state.content.isEmpty ||
                    calendarViewModel.state.selectedDate == nil
                )
                .buttonStyle(LargeButtonStyle())
                .padding(.top, 30)
            }
            .padding(24)
        }
        .background(TLColor.backgroundGray.ignoresSafeArea())
        .onChange(of: selectedItem) { items in
            handleItem(items: items)
        }
        .onChange(of: viewModel.state.onCompleted) { _ in
            dismiss()
        }
    }
    
    @ViewBuilder
    var contentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("내용")
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            TextField("여행의 내용을 입력하세요", text: $viewModel.state.content)
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.skyBlueLight.opacity(0.2)))
                .textFieldStyle(PlainTextFieldStyle())
        }
    }
    
    @ViewBuilder
    var imageSelectionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("사진")
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(viewModel.state.selectedImage, id: \.self) { data in
                        if let uiImage = UIImage(data: data) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.white, lineWidth: 2)
                                )
                        }
                    }
                    
                    PhotosPicker(selection: $selectedItem) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(TLColor.skyBlueLight.opacity(0.4))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(TLColor.primaryText)
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var dateView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("날짜")
                .font(TLFont.headline)
                .foregroundColor(TLColor.primaryText)
            
            CalendarView(viewModel: calendarViewModel)
                .padding()
                .background(RoundedRectangle(cornerRadius: 12).fill(TLColor.skyBlueLight.opacity(0.2)))
        }
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
                        print("Data is nil")
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

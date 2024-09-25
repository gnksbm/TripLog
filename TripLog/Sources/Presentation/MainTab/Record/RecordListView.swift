//
//  RecordListView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI

struct RecordListView: View {
    @StateObject private var viewModel = RecordListViewModel()
    @StateObject private var addRecordViewModel = AddRecordViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.state.list.isEmpty {
                    emptyPlacehoderView
                } else {
                    listView
                        .navigationDestination(
                            isPresented: Binding(
                                get: { viewModel.state.detailRecord != nil },
                                set: { isPresented in
                                    if !isPresented {
                                        viewModel.send(action: .detailDismissed)
                                    }
                                }
                            )
                        ) {
                            if let record = viewModel.state
                                .detailRecord {
                                recordView(record: record)
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.send(action: .addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(isPresented: $viewModel.state.showAddView) {
                AddRecordView(viewModel: addRecordViewModel)
                    .onAppear {
                        addRecordViewModel.delegate = viewModel
                    }
            }
        }
        .onAppear {
            viewModel.send(action: .onAppear)
        }
    }
    
    var listView: some View {
        ScrollView {
            ForEach(viewModel.state.list) { record in
                recordView(record: record)
                    .onTapGesture {
                        viewModel.send(action: .itemTapped(record))
                    }
            }
        }
    }
    
    var emptyPlacehoderView: some View {
        Text("아직 기록한 여행이 없어요")
    }
    
    @ViewBuilder
    func recordView(record: TravelRecord) -> some View {
        LocalImageView(path: record.imageURLs.first)
            .frame(height: UIScreen.main.bounds.width)
        Text(record.dateStr)
        Text(record.content)
            .lineLimit(2)
        Rectangle()
            .fill(.quaternary)
            .padding(.vertical)
    }
}

#Preview {
    DIContainer.register(
        MockRecordRepository(),
        type: RecordRepository.self
    )
    return RecordListView()
}

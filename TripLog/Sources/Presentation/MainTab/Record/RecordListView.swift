//
//  RecordListView.swift
//  TripLog
//
//  Created by gnksbm on 9/12/24.
//

import SwiftUI

struct RecordListView: View {
    @StateObject private var viewModel = RecordListViewModel()
    
    var body: some View {
        NavigationStack {
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
        EmptyView()
    }
    
    @ViewBuilder
    func recordView(record: TravelRecord) -> some View {
        if let thumbnailImageURL = record.thumbnailImageURL {
            AsyncImage(
                url: FileManager.getLocalImageURL(
                    additionalPath: thumbnailImageURL
                )
            )
        } else {
            Color.secondary
        }
        Text(record.title)
            .bold()
        Text(record.peoridStr)
        if let thumbnailContent = record.thumbnailContent {
            Text(thumbnailContent)
                .lineLimit(2)
        }
    }
}

#Preview {
    DIContainer.register(
        MockRecordRepository(),
        type: RecordRepository.self
    )
    return RecordListView()
}

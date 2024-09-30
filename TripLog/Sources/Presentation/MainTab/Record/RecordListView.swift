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
                    emptyPlaceholderView
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
                            if let record = viewModel.state.detailRecord {
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
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(TLColor.oceanBlue)
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
        .background(TLColor.backgroundGray.ignoresSafeArea())
        .onAppear {
            viewModel.send(action: .onAppear)
        }
    }
    
    var listView: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(viewModel.state.list) { record in
                    recordView(record: record)
                        .onTapGesture {
                            viewModel.send(action: .itemTapped(record))
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(TLColor.skyBlueLight.opacity(0.2))
                                .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                        )
                        .padding(.horizontal)
                }
            }
            .padding(.top, 16)
        }
    }
    
    var emptyPlaceholderView: some View {
        VStack(spacing: 16) {
            Image(systemName: "square.and.pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(TLColor.secondaryText)
            
            Text("아직 기록한 여행이 없어요")
                .font(TLFont.headline)
                .foregroundColor(TLColor.secondaryText)
            
            Text("새로운 여행 기록을 추가해보세요.")
                .font(TLFont.caption)
                .foregroundColor(TLColor.secondaryText)
            
            Button {
                viewModel.send(action: .addButtonTapped)
            } label: {
                Label("기록 추가하기", systemImage: "plus")
                    .font(TLFont.body)
                    .foregroundColor(.white)
                    .padding()
                    .background(Capsule().fill(TLColor.oceanBlue))
            }
            .padding(.top, 20)
        }
        .padding()
    }
    
    @ViewBuilder
    func recordView(record: TravelRecord) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            LocalImageView(path: record.imageURLs.first)
                .frame(height: UIScreen.main.bounds.width * 0.6)
                .cornerRadius(12)
                .clipped()
            
            Text(record.dateStr)
                .font(TLFont.subHeadline)
                .foregroundColor(TLColor.primaryText)
            
            Text(record.content)
                .font(TLFont.body)
                .foregroundColor(TLColor.primaryText)
                .lineLimit(2)
            
            Divider()
                .background(TLColor.separatorGray)
                .padding(.vertical, 8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 16)
    }
}

#Preview {
    DIContainer.register(
        MockRecordRepository(),
        type: RecordRepository.self
    )
    return RecordListView()
}

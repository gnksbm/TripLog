//
//  AddRecordViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

final class AddRecordViewModel: ViewModel {
    @Injected private var imageRepository: ImageRepository
    @Injected private var recordRepository: RecordRepository
    
    @Published var state = State()
    
    weak var delegate: CompleteDelegate?
    
    func mutate(action: Action) {
        switch action {
        case .imageSeledted(let datas):
            state.selectedImage = datas
        case .doneButtonTapped(let date):
            Task {
                let recordID = UUID().uuidString
                let imageURLs = try await imageRepository.saveImages(
                    id: recordID,
                    datas: state.selectedImage
                )
                try await recordRepository.addRecord(
                    id: recordID,
                    date: date,
                    content: state.content,
                    imageURLs: imageURLs
                )
                state.onCompleted = true
                delegate?.onComplete()
            }
        }
    }
}

extension AddRecordViewModel {
    struct State {
        var content = ""
        var selectedImage = [Data]()
        var onCompleted = false
    }
    
    enum Action {
        case imageSeledted([Data])
        case doneButtonTapped(Date)
    }
}

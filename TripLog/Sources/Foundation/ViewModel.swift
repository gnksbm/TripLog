//
//  ViewModel.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

protocol ViewModel: ObservableObject {
    associatedtype State
    associatedtype Action
    
    var state: State { get set }
    
    func mutate(action: Action)
}

extension ViewModel {
    func send(action: Action) {
        mutate(action: action)
    }
}

//
//  Debouncer.swift
//  TripLog
//
//  Created by gnksbm on 9/30/24.
//

import Foundation

final class Debouncer {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue
    
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }
    
    func run(action: @escaping () -> Void) {
        workItem?.cancel()
        let workItem = DispatchWorkItem(block: action)
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        self.workItem = workItem
    }
    
    func runOnMain(action: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            run(action: action)
        }
    }
    
    func cancel() {
        workItem?.cancel()
    }
}

//
//  Throttle.swift
//  TripLog
//
//  Created by gnksbm on 10/2/24.
//

import Foundation

final class Throttle {
    private let delay: TimeInterval
    private var workItem: DispatchWorkItem?
    private let queue: DispatchQueue

    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }

    func run(action: @escaping () -> Void) {
        if self.workItem == nil {
            action()
            let workItem = DispatchWorkItem {
                self.workItem?.cancel()
                self.workItem = nil
            }
            self.workItem = workItem
            queue.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
    
    func runWithCancel(action: @escaping () -> Void) {
        self.workItem?.cancel()
        self.workItem = nil
        action()
        let workItem = DispatchWorkItem {
            self.workItem?.cancel()
            self.workItem = nil
        }
        self.workItem = workItem
        queue.asyncAfter(
            deadline: .now() + delay,
            execute: workItem
        )
    }
    
    func runOnMain(action: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            run(action: action)
        }
    }
    
    func runWithCancelOnMain(action: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            runWithCancel(action: action)
        }
    }
}

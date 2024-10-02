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
    private var priority: UInt = 0
    
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }
    
    func run(priority: UInt = 0, action: @escaping () -> Void) {
        if self.workItem == nil {
            work(priority: priority, action: action)
        } else {
            if priority > self.priority {
                workItem?.cancel()
                workItem = nil
                work(priority: priority, action: action)
            }
        }
    }
    
    func runOnMain(priority: UInt = 0, action: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            run(priority: priority, action: action)
        }
    }
    
    private func work(priority: UInt = 0, action: @escaping () -> Void) {
        self.priority = priority
        action()
        let workItem = DispatchWorkItem {
            self.workItem?.cancel()
            self.workItem = nil
            self.priority = 0
        }
        self.workItem = workItem
        queue.asyncAfter(deadline: .now() + delay, execute: workItem)
    }
}

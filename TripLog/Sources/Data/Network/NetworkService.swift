//
//  NetworkService.swift
//  TripLog
//
//  Created by gnksbm on 9/13/24.
//

import Foundation

protocol NetworkService {
    func request<T: Endpoint>(endpoint: T) async throws -> Data
}

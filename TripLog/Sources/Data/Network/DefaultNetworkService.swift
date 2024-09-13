//
//  DefaultNetworkService.swift
//  TripLog
//
//  Created by gnksbm on 9/13/24.
//

import Foundation

final class DefaultNetworkService: NetworkService {
    private var urlSession: URLSession {
        URLSession.shared
    }
    
    func request<T: Endpoint>(endpoint: T) async throws -> Data {
        guard let request = endpoint.toURLRequest() else {
            throw NetworkError.invalidRequest
        }
        let (data, response) = try await urlSession.data(for: request)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard 200..<300 ~= response.statusCode else {
            throw NetworkError.invalidStatusCode(response.statusCode)
        }
        return data
    }
    
    enum NetworkError: Error {
        case invalidRequest, invalidResponse, invalidStatusCode(Int)
    }
}

//
//  Endpoint.swift
//  TripLog
//
//  Created by gnksbm on 9/13/24.
//

import Foundation

enum HTTPMethod: String {
    case http, https, ws
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var scheme: String { get }
    var host: String { get }
    var port: Int? { get }
    var path: String { get }
    var queries: [String: String]? { get }
    var header: [String : String]? { get }
    var body: [String: any Encodable]? { get }
    
    func toURLRequest() -> URLRequest?
    func toURL() -> URL?
}

extension Endpoint {
    var port: Int? { nil }
    var queries: [String: String]? { nil }
    var header: [String : String]? { nil }
    var body: [String: any Encodable]? { nil }
    
    func toURLRequest() -> URLRequest? {
        guard let url = toURL() else { return nil }
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = header
        request.httpMethod = httpMethod.rawValue
        if let body {
            let httpBody = try? JSONSerialization.data(withJSONObject: body)
            request.httpBody = httpBody
        }
        return request
    }
    
    func toURL() -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url
    }
}

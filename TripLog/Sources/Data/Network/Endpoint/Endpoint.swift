//
//  Endpoint.swift
//  TripLog
//
//  Created by gnksbm on 9/13/24.
//

import Foundation

enum Scheme: String {
    case http, https, ws
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var scheme: Scheme { get }
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
        components.scheme = scheme.rawValue
        components.host = host
        components.path = path
        components.port = port
        components.queryItems = queries?.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let urlStr = components.url?.absoluteString
            .replacingOccurrences(of: "%25", with: "%")
        else { return nil }
        return URL(string: urlStr)
    }
}

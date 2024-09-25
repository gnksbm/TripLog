//
//  FileManager+.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

extension FileManager {
    static var documentURL: URL {
        guard let url = Self.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else { fatalError("Document 경로 찾을 수 없음") }
        return url
    }
    
    static func getLocalImageURL(additionalPath: String) -> URL {
        documentURL.appendingPathComponent(
            additionalPath,
            conformingTo: .jpeg
        )
    }
}

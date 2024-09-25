//
//  ImageRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

protocol ImageRepository {
    func saveImages(id: String, datas: [Data]) async throws -> [String]
}

final class DefaultImageRepository: ImageRepository {
    func saveImages(id: String, datas: [Data]) async throws -> [String] {
        var urls = [String]()
        try (datas.enumerated()).forEach { index, data in
            let path = "\(id)\(index)"
            let url = FileManager.documentURL.appendingPathComponent(
                path,
                conformingTo: .jpeg
            )
            try data.write(to: url)
            urls.append(path)
        }
        return urls
    }
}

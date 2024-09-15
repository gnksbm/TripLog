//
//  TouristRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

protocol TouristRepository { 
    func fetchAreaCode() async throws -> [AreaCodeResponse]
}

final class DefaultTouristRepository: TouristRepository {
    @Injected private var networkService: NetworkService
    
    func fetchAreaCode() async throws -> [AreaCodeResponse] {
        try await networkService.request(
            endpoint: AreaCodeEndpoint(
                request: AreaCodeRequest()
            )
        )
        .decode(type: AreaCodeDTO.self)
        .toResponse()
    }
}

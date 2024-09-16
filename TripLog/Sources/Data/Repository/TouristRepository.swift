//
//  TouristRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

protocol TouristRepository { 
    func fetchAreaCode() async throws -> [AreaCodeResponse]
    func fetchFestival(areaCode: Int) async throws -> [SearchFestivalResponse]
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
    
    func fetchFestival(areaCode: Int) async throws -> [SearchFestivalResponse] {
        try await networkService.request(
            endpoint: SearchFestivalEndpoint(
                request: SearchFestivalRequest(
                    areaCode: areaCode,
                    eventStartDate: .now,
                    eventEndDate: nil
                )
            )
        )
        .decode(type: SearchFestivalDTO.self)
        .toResponse()
    }
}

//
//  TouristRepository.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import CoreLocation
import Foundation

protocol TouristRepository { 
    func fetchAreaCode() async throws -> [AreaCodeResponse]
    func fetchFestival(areaCode: Int) async throws -> [SearchFestivalResponse]
    func fetchTouristInformations(
        page: Int,
        numOfPage: Int,
        location: CLLocation
    ) async throws -> [TouristPlaceResponse]
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
    
    func fetchTouristInformations(
        page: Int,
        numOfPage: Int,
        location: CLLocation
    ) async throws -> [TouristPlaceResponse] {
        let endpoint = TouristPlaceEndpoint(
            request: TouristPlaceRequest(
                pageNo: page,
                numOfPage: numOfPage,
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
        )
        return try await networkService.request(endpoint: endpoint)
            .decode(type: TouristPlaceDTO.self)
            .toResponse()
    }
}

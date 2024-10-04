//
//  DefaultTouristRepository.swift
//  TripLog
//
//  Created by gnksbm on 10/3/24.
//

import CoreLocation
import Foundation

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
    
    func fetchFestival(
        pageNo: Int?,
        numOfRows: Int?,
        areaCode: Int
    ) async throws -> [SearchFestivalResponse] {
        try await networkService.request(
            endpoint: SearchFestivalEndpoint(
                request: SearchFestivalRequest(
                    pageNo: pageNo,
                    numOfRows: pageNo,
                    areaCode: areaCode,
                    eventStartDate: .now,
                    eventEndDate: nil
                )
            )
        )
        .decode(type: SearchFestivalDTO.self)
        .toResponse()
    }
    
    func fetchFestivalWithPage(
        pageNo: Int?,
        numOfRows: Int?,
        areaCode: Int
    ) async throws -> (page: Int, total: Int, list: [SearchFestivalResponse]) {
        try await networkService.request(
            endpoint: SearchFestivalEndpoint(
                request: SearchFestivalRequest(
                    pageNo: pageNo,
                    numOfRows: numOfRows,
                    areaCode: areaCode,
                    eventStartDate: .now,
                    eventEndDate: nil
                )
            )
        )
        .decode(type: SearchFestivalDTO.self)
        .toResponseWithPageInfo()
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
    
    func fetchDetail(
        contentID: String,
        contentTypeID: String
    ) async throws {
        let endpoint = DetailCommonEndpoint(
            request: DetailCommonRequest(
                contentID: contentID,
                contentTypeID: contentTypeID
            )
        )
        let data = try await networkService.request(endpoint: endpoint)
        print(String(data: data, encoding: .utf8) ?? "nil")
    }
}

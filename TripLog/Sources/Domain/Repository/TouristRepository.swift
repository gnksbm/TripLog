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
    
    func fetchFestival(
        pageNo: Int?,
        numOfRows: Int?,
        areaCode: Int
    ) async throws -> [SearchFestivalResponse]
    
    func fetchFestivalWithPage(
        pageNo: Int?,
        numOfRows: Int?,
        areaCode: Int
    ) async throws -> (page: Int, total: Int, list: [SearchFestivalResponse])
    
    func fetchTouristInformations(
        page: Int,
        numOfPage: Int,
        location: CLLocation
    ) async throws -> [TouristPlaceResponse]
    
    func fetchDetail(
        contentID: String,
        contentTypeID: String
    ) async throws
}

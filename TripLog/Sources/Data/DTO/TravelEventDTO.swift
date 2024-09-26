//
//  TravelEventDTO.swift
//  TripLog
//
//  Created by gnksbm on 9/25/24.
//

import Foundation

import RealmSwift

final class TravelEventDTO: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var date: Date
    @Persisted var locationInfo: LocationInformationDTO?
    
    convenience init(
        _ entity: TravelEvent
    ) {
        self.init()
        id = entity.id
        title = entity.title
        date = entity.date
        locationInfo = LocationInformationDTO(entity.locationInfo)
    }
}

extension TravelEventDTO {
    func toDomain() -> TravelEvent {
        TravelEvent(
            id: id,
            title: title,
            date: date,
            locationInfo: locationInfo?.toDomain()
        )
    }
}

final class LocationInformationDTO: Object {
    @Persisted var title: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
}

extension LocationInformationDTO {
    func toDomain() -> LocationInformation {
        LocationInformation(
            title: title,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    convenience init?(
        _ entity: LocationInformation?
    ) {
        guard let entity else { return nil }
        self.init()
        title = entity.title
        latitude = entity.latitude
        longitude = entity.longitude
    }
}

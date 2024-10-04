//
//  SearchFestivalResponse.swift
//  TripLog
//
//  Created by gnksbm on 9/16/24.
//

import Foundation

struct SearchFestivalResponse: Hashable, LocationInfoItemType {
    let contentID: String
    let contentTypeID: String
    let title: String
    let address: String
    let latitude: Double
    let longitude: Double
    let startDate: Date
    let endDate: Date
    let imageURLs: [URL]
}

extension SearchFestivalResponse {
    var period: DateInterval? {
        DateInterval(first: startDate, second: endDate)
    }
}

#if DEBUG
extension SearchFestivalResponse {
    static let mock = SearchFestivalResponse(
        contentID: "2648460",
        contentTypeID: "",
        title: "경복궁 별빛야행",
        address: "서울특별시 종로구 사직로 161 (세종로)",
        latitude: 126.9767375783,
        longitude: 37.5760836609,
        startDate: "20240911".formatted(dateFormat: .festivalInput)!,
        endDate: "20241006".formatted(dateFormat: .festivalInput)!,
        imageURLs: [
            URL(string: "http://tong.visitkorea.or.kr/cms/resource/24/3349624_image2_1.png")!,
            URL(string: "http://tong.visitkorea.or.kr/cms/resource/24/3349624_image3_1.png")!
        ]
    )
}
#endif

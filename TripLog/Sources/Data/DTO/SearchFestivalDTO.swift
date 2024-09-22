//
//  SearchFestivalDTO.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

struct SearchFestivalDTO: Codable {
    let response: Response
}

extension SearchFestivalDTO {
    func toResponse() -> [SearchFestivalResponse] {
        response.body.items.item.compactMap { item in
            var imageURLs = [URL]()
            guard let latitude = Double(item.mapy),
                  let longitude = Double(item.mapx),
                  let startDate = item.eventstartdate?.formatted(
                    dateFormat: .festivalInput
                  ),
                  let endDate = item.eventenddate.formatted(
                    dateFormat: .festivalInput
                  )
            else { return nil }
            [item.firstimage, item.firstimage2].forEach { str in
                if let url = URL(string: str) {
                    imageURLs.append(url)
                }
            }
            return SearchFestivalResponse(
                contentID: item.contentid,
                title: item.title,
                address: item.addr1,
                latitude: latitude,
                longitude: longitude,
                startDate: startDate,
                endDate: endDate,
                imageURLs: imageURLs
            )
        }
    }
}

extension SearchFestivalDTO {
    struct Response: Codable {
        let header: Header
        let body: Body
    }
    
    struct Body: Codable {
        let items: Items
        let numOfRows, pageNo, totalCount: Int
    }
    
    struct Items: Codable {
        let item: [Item]
    }
    
    struct Item: Codable {
        let addr1, addr2, booktour: String
        let cat1, cat2, cat3: String
        let contentid, contenttypeid, createdtime: String
        let eventstartdate: String?
        let eventenddate: String
        let firstimage, firstimage2: String
        let cpyrhtDivCD: String
        let mapx, mapy, mlevel, modifiedtime: String
        let areacode, sigungucode, tel, title: String
        
        enum CodingKeys: String, CodingKey {
            case addr1, addr2, booktour, cat1, cat2, cat3, contentid
            case contenttypeid, createdtime, eventstartdate, eventenddate
            case firstimage, firstimage2
            case cpyrhtDivCD = "cpyrhtDivCd"
            case mapx, mapy, mlevel, modifiedtime, areacode, sigungucode, tel
            case title
        }
    }
    
    enum Cat1: String, Codable {
        case a02 = "A02"
    }
    
    enum Cat2: String, Codable {
        case a0207 = "A0207"
        case a0208 = "A0208"
    }
    
    enum Cat3: String, Codable {
        case a02070100 = "A02070100"
        case a02070200 = "A02070200"
        case a02081300 = "A02081300"
    }
    
    struct Header: Codable {
        let resultCode, resultMsg: String
    }
}

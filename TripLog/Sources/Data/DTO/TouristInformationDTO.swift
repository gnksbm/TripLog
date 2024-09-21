//
//  TouristInformationDTO.swift
//  TripLog
//
//  Created by gnksbm on 9/21/24.
//

import Foundation

struct TouristInformationDTO: Codable {
    let response: Response
}

extension TouristInformationDTO {
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
        let firstimage, firstimage2: String
        let cpyrhtDivCD: String
        let mapx, mapy, mlevel, modifiedtime: String
        let areacode, sigungucode, tel, title: String
        
        enum CodingKeys: String, CodingKey {
            case addr1, addr2, booktour, cat1, cat2, cat3, contentid
            case contenttypeid, createdtime
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

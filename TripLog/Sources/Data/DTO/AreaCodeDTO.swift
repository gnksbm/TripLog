//
//  AreaCodeDTO.swift
//  TripLog
//
//  Created by gnksbm on 9/15/24.
//

import Foundation

struct AreaCodeDTO: Decodable {
    let response: Response
}

extension AreaCodeDTO {
    struct Response: Decodable {
        let header: Header
        let body: Body
    }
    
    struct Header: Decodable {
        let resultCode, resultMsg: String
    }
    
    struct Body: Decodable {
        let numOfRows, pageNo, totalCount: Int
        let items: Items
    }
    
    struct Items: Decodable {
        let item: [Item]
    }
    
    struct Item: Decodable {
        let rnum: Int
        let code, name: String
    }
}

extension AreaCodeDTO {
    func toResponse() -> [AreaCodeResponse] {
        response.body.items.item
            .compactMap { item in
                guard let areaCode = Int(item.code) else { return nil }
                return AreaCodeResponse(
                    areaCode: areaCode,
                    areaName: item.name
                )
            }
    }
}

//
//  StationResponseModel.swift
//  SubwayStation
//
//  Created by 김초원 on 2023/01/19.
//

import Foundation

struct StationResponseModel: Decodable {
    var stations: [Station] { seachInfo.row }
    
    private let seachInfo: SearchInfoBySubwayNameServiceModel
    
    enum CodingKeys: String, CodingKey {
        case seachInfo = "SearchInfoBySubwayNameService"
    }
    
    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [Station]
    }
}

struct Station: Decodable {
    let stationName: String
    let lineNumber: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}


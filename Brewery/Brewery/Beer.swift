//
//  Beer.swift
//  Brewery
//
//  Created by 김초원 on 2023/01/16.
//

import Foundation

struct Beer: Decodable {
    let id: Int?
    let name, taglineString, description, brewersTips, imageURL: String?
    let foodPairing: [String]?
    
    var tagLine: String {
        let tags = taglineString?.components(separatedBy: ". ")
        let hashtags = tags?.compactMap {
            "#" + $0.replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: ".", with: "")
                .replacingOccurrences(of: ",", with: "#")
        }
        return hashtags?.joined(separator: " ") ?? ""
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case imageURL = "image_url"
        case taglineString = "tagline"
        case brewersTips = "brewers_tips"
        case foodPairing = "food_pairing"
    }
}

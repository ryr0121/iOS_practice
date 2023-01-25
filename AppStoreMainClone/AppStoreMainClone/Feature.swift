//
//  Feature.swift
//  AppStoreMainClone
//
//  Created by 김초원 on 2023/01/25.
//

import Foundation

struct Feature: Decodable {
    let type: String
    let appName: String
    let description: String
    let imageURL: String
}

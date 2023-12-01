//
//  MapperResponseDTO.swift
//  Domain
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

struct MapperResponseDTO: Codable {
    let region: [Category]
    let job: [Job]
    let skill: [String]
    let category: [Category]
}

// MARK: - Category
struct Category: Codable {
    let name, key: String
}

// MARK: - Job
struct Job: Codable {
    let name, key: String
    let value: [Category]
}

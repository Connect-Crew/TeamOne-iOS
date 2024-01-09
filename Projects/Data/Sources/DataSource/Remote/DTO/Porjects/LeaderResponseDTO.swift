//
//  LeaderResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/9/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

struct LeaderResponseDTO: Codable {
    let id: Int
    let profile: String?
    let nickname, introduction: String
    let temperature: Double
    let responseRate: Int
    let parts: [String]
    let representProjects: [RepresentProjectResponseDTO]

    func toDoamin() -> Domain.Leader {
        return Domain.Leader(
            id: self.id,
            nickname: self.nickname,
            profile: self.profile ?? "",
            introduction: self.introduction,
            temperature: self.temperature,
            responseRate: self.responseRate,
            parts: self.parts,
            representProjects: self.representProjects.map { $0.toDomain()
            })
    }
}

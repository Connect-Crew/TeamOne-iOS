//
//  BaseUserResponseDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct BaseUserResponseDTO: Codable {
    let id: Int
    let nickname: String
    let profile: String?
    let introduction: String
    let temperature: Double
    let responseRate: Int
    let parts: [BasePartsResponseDTO]
    let representProjects: [RepresentProjectResponseDTO]
    
    public func toDomain() -> Profile {
        return Profile(id: self.id,
                       nickname: self.nickname,
                       profile: self.profile ?? "",
                       introduction: self.introduction,
                       temperature: self.temperature,
                       responseRate: self.responseRate,
                       parts: self.parts.map { $0.toDomain() },
                       representProjects: self.representProjects.map { $0.toDomain() })
    }
}



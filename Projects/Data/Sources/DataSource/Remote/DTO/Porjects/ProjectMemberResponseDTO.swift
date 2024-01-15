//
//  ProjectMemberResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct ProjectMemberResponseDTO: Codable {
    let profile: BaseUserResponseDTO
    let isLeader: Bool
    let parts: [String]
    
    func toDomain() -> ProjectMember {
        return ProjectMember(
            profile: Profile(
                id: self.profile.id,
                nickname: self.profile.nickname,
                profile: self.profile.profile ?? "",
                introduction: self.profile.introduction,
                temperature: self.profile.temperature,
                responseRate: self.profile.responseRate,
                parts: self.profile.parts.map { $0.toDomain() },
                representProjects: self.profile.representProjects.map { $0.toDomain() }
            ),
            isLeader: self.isLeader,
            parts: self.parts
        )
    }
}

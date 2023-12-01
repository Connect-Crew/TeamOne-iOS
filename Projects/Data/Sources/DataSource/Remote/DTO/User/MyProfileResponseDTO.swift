//
//  MyProfileResponseDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct MyProfileResponseDTO: Codable {
    let id: Int
    let nickname: String
    let profile: String?
    let introduction: String
    let temperature: Double
    let responseRate: Int
    let parts: [String]
    let representProjects: [RepresentProject]

    public func toDomain() -> MyProfile {
        return MyProfile(id: self.id,
                         nickname: self.nickname,
                         profile: self.profile ?? "",
                         introduction: self.introduction,
                         temperature: self.temperature,
                         responseRate: self.responseRate,
                         parts: self.parts,
                         representProjects: self.representProjects.map { $0.toDomain() })
    }

    struct RepresentProject: Codable {
        let id: Int
        let thumbnail: String

        func toDomain() -> MyProfile.RepresentProject {
            return MyProfile.RepresentProject(
                id: self.id,
                thumbnail: self.thumbnail
            )
        }
    }
}



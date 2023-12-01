//
//  ProjectResponseDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct ProjectResponseDTO: Codable {
    let id: Int
    let title: String
    let banners: [String]
    let region: String
    let online: Bool
    let createdAt, state, careerMin, careerMax: String
    let category: [String]
    let goal: String
    let leader: LeaderResponse
    let introduction: String
    let favorite: Int
    let myFavorite: Bool
    let recruitStatus: [RecruitStatusResponse]
    let skills: [String]

    func toDomain() -> Project {
        return Project(id: self.id, title: self.title, banners: self.banners, region: self.region, online: self.online, createdAt: self.createdAt, state: self.state, careerMin: self.careerMin, careerMax: self.careerMax, category: self.category, goal: self.goal, leader: self.leader.toDoamin(), introduction: self.introduction, favorite: self.favorite, myFavorite: self.myFavorite, recruitStatus: self.recruitStatus.map { $0.toDomain()}, skills: self.skills)
    }

    struct LeaderResponse: Codable {
        let id: Int
        let profile: String?
        let nickname, introduction: String
        let temperature: Double
        let responseRate: Int
        let parts: [String]
        let representProjects: [RepresentProjectResponse]

        func toDoamin() -> Domain.Leader {
            return Domain.Leader(id: self.id, nickname: self.nickname, profile: self.profile ?? "", introduction: self.introduction, temperature: self.temperature, responseRate: self.responseRate, parts: self.parts, representProjects: self.representProjects.map { $0.toDomain() })
        }
    }

    struct RepresentProjectResponse: Codable {
        let id: Int
        let thumbnail: String

        func toDomain() -> Domain.RepresentProject {
            return Domain.RepresentProject(id: self.id, thumbnail: self.thumbnail)
        }
    }

    struct RecruitStatusResponse: Codable {
        let category, part, partKey, comment: String
        let current, max: Int
        let applied: Bool

        func toDomain() -> Domain.RecruitStatus {
            return Domain.RecruitStatus(category: self.category, part: self.part, partKey: self.partKey, comment: self.comment, current: self.current, max: self.max, applied: self.applied)
        }
    }
}



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
    let leader: LeaderResponseDTO
    let introduction: String
    let favorite: Int
    let myFavorite: Bool
    let recruitStatus: [RecruitStatusResponseDTO]
    let skills: [String]

    func toDomain() -> Project {
        return Project(id: self.id, title: self.title, banners: self.banners, region: self.region, online: self.online, createdAt: self.createdAt, state: self.state, careerMin: self.careerMin, careerMax: self.careerMax, category: self.category, goal: self.goal, leader: self.leader.toDoamin(), introduction: self.introduction, favorite: self.favorite, myFavorite: self.myFavorite, recruitStatus: self.recruitStatus.map { $0.toDomain()}, skills: self.skills)
    }
}



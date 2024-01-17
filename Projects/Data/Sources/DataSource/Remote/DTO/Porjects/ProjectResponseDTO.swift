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
    var recruitStatus: [RecruitStatusResponseDTO]
    let skills: [String]

    func toDomain() -> Project {
        
        // 리더의 직무를 분리
        let leaderParts = recruitStatus.filter { $0.containLeader == true }.first!
        
        // 리더의 직무가 제외된 모집 내용
        let exceptLeaerRecruitStatus = RecruitStatusResponseDTO.exceptLeaerPosition(status: self.recruitStatus)
        
        return Project(
            id: self.id,
            title: self.title,
            banners: self.banners,
            region: self.region,
            online: self.online,
            createdAt: self.createdAt,
            state: self.state,
            careerMin: self.careerMin,
            careerMax: self.careerMax,
            category: self.category,
            goal: self.goal,
            leader: self.leader.toDoamin(),
            leaderParts: leaderParts.toDomain(),
            introduction: self.introduction,
            favorite: self.favorite,
            myFavorite: self.myFavorite,
            recruitStatus: exceptLeaerRecruitStatus.map { $0.toDomain() },
            skills: self.skills)
    }
}

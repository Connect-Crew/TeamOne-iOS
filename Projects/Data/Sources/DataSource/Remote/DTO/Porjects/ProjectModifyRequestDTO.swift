//
//  ProjectModifyRequestDTO.swift
//  Data
//
//  Created by 강현준 on 1/17/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
public struct ProjectModifyRequestDTO {
    /// 프로젝트 배너 이미지
    let banner: [ImageUploadRequestDTO]
    let removeBanners: [String]
    let title: String
    let region: String
    let online: Bool
    let state: String
    let careerMin: String
    let careerMax: String
    let leaderParts: String
    let category: [String]
    let goal: String
    let introduction: String
    let recruits: [ProjectRecruitDTO]
    let skills: [String]
    
    init(banner: [ImageUploadRequestDTO], removeBanners: [String], title: String, region: String, online: Bool, state: String, careerMin: String, careerMax: String, leaderParts: String, category: [String], goal: String, introduction: String, recruits: [ProjectRecruitDTO], skills: [String]) {
        self.banner = banner
        self.removeBanners = removeBanners
        self.title = title
        self.region = region
        self.online = online
        self.state = state
        self.careerMin = careerMin
        self.careerMax = careerMax
        self.leaderParts = leaderParts
        self.category = category
        self.goal = goal
        self.introduction = introduction
        self.recruits = recruits
        self.skills = skills
    }
}

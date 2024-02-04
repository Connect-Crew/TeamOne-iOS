//
//  MyProjects.swift
//  Domain
//
//  Created by Junyoung on 2/5/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct MyProjects: Codable {
    let id: Int
    let title: String
    let thumbnail: String?
    let region: String
    let online: Bool
    let careerMin, careerMax: String
    let createdAt: String
    let state: String
    let favorite: Int
    let myFavorite: Bool
    let category: [String]
    let goal: String
    let recruitStatus: [RecruitStatus]
    
    public init(id: Int, title: String, thumbnail: String?, region: String, online: Bool, careerMin: String, careerMax: String, createdAt: String, state: String, favorite: Int, myFavorite: Bool, category: [String], goal: String, recruitStatus: [RecruitStatus]) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.region = region
        self.online = online
        self.careerMin = careerMin
        self.careerMax = careerMax
        self.createdAt = createdAt
        self.state = state
        self.favorite = favorite
        self.myFavorite = myFavorite
        self.category = category
        self.goal = goal
        self.recruitStatus = recruitStatus
    }
}

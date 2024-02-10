//
//  MyProjects.swift
//  Domain
//
//  Created by Junyoung on 2/5/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct MyProjects: Codable, Hashable {
    public let id: Int
    public let title: String
    public let thumbnail: String?
    public let region: String
    public let online: Bool
    public let careerMin, careerMax: String
    public let createdAt: String
    public let state: String
    public let favorite: Int
    public let myFavorite: Bool
    public let category: [String]
    public let goal: String
    public let recruitStatus: [RecruitStatus]
    
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

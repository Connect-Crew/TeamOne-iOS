//
//  MyProjectsDSModel.swift
//  DSKit
//
//  Created by Junyoung on 2/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct MyProjectsDSModel: Codable {
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
    let recruitStatus: [RecruitStatusDSModel]
    
    public init(id: Int, title: String, thumbnail: String?, region: String, online: Bool, careerMin: String, careerMax: String, createdAt: String, state: String, favorite: Int, myFavorite: Bool, category: [String], goal: String, recruitStatus: [RecruitStatusDSModel]) {
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

public struct RecruitStatusDSModel: Codable, Hashable {
    public let category: String
    public let part: String
    public let partKey: String
    public let comment: String
    public var current, max: Int
    public var applied: Bool
    public var isQuotaFull: Bool

    public init(category: String, part: String, partKey: String, comment: String, current: Int, max: Int, applied: Bool) {
        self.category = category
        self.part = part
        self.partKey = partKey
        self.comment = comment
        self.current = current
        self.max = max
        self.applied = applied

        self.isQuotaFull = current >= max ? true : false
    }
}

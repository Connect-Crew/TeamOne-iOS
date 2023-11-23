//
//  SideProjectListElement.swift
//  DomainTests
//
//  Created by 강현준 on 2023/10/30.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public struct SideProjectListElement {

    public let id: Int
    public let title: String
    public let thumbnail: String?
    public let region: String
    public let online: Bool
    public let careerMin, careerMax: String
    public let createdAt: String
    public let state: String
    public var favorite: Int
    public var myFavorite: Bool
    public let category: [String]
    public let goal: String
    public let recruitStatus: [RecruitStatus]
    public var HashTags: [HashTag] = []

    public struct RecruitStatus: Codable {
        public let category: String
        public let part, comment: String
        public let current, max: Int

        public init(category: String, part: String, comment: String, current: Int, max: Int) {
            self.category = category
            self.part = part
            self.comment = comment
            self.current = current
            self.max = max
        }
    }

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

        self.HashTags.append(HashTag(title: state, background: .pink, titleColor: .gray))

        if careerMin == "경력무관" {
            self.HashTags.append(HashTag(title: "경력 무관", background: .pink, titleColor: .gray))
        } else {
            self.HashTags.append(HashTag(title: "\(careerMin) 차 이상", background: .pink, titleColor: .gray))
        }
        self.HashTags.append(HashTag(title: goal, background: .gray, titleColor: .gray))
        category.forEach {
            self.HashTags.append(HashTag(title: $0, background: .gray, titleColor: .gray))
        }
    }
}

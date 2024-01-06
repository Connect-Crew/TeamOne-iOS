//
//  SideProjectListElement.swift
//  DomainTests
//
//  Created by 강현준 on 2023/10/30.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public struct SideProjectListElement: Hashable {
    public static func == (lhs: SideProjectListElement, rhs: SideProjectListElement) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(favorite)
    }
    
    public let identifier = UUID()
    public let id: Int
    public let title: String
    public let thumbnail: String?
    public let region: String
    public let online: Bool
    public let careerMin, careerMax: Career
    public let createdAt: String
    public let state: String
    public var favorite: Int
    public var myFavorite: Bool
    public let category: [String]
    public let goal: Purpose
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
        self.careerMin = Career.findCareer(string: careerMin)
        self.careerMax = Career.findCareer(string: careerMax)
        self.createdAt = createdAt
        self.state = state
        self.favorite = favorite
        self.myFavorite = myFavorite
        self.category = category
        self.goal = Purpose.findCellStringToPurpose(string: goal)
        self.recruitStatus = recruitStatus
        
        setHashTags()
    }
    
    mutating func setHashTags() {
        self.HashTags.append(HashTag(title: state, background: .pink, titleColor: .gray))
        self.HashTags.append(HashTag(title: "\(self.careerMin.toCellString())", background: .pink, titleColor: .gray))
        self.HashTags.append(HashTag(title: "\(self.goal.toCellString())", background: .gray, titleColor: .gray))
        category.forEach {
            self.HashTags.append(HashTag(title: $0, background: .gray, titleColor: .gray))
        }
    }
}

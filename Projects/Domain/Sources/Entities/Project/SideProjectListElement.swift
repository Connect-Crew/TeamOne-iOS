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
    public let isOnline: isOnline
    public var careerMin, careerMax: Career
    public let createdAt: String
    public let state: ProjectState
    public var favorite: Int
    public var myFavorite: Bool
    public let category: [String]
    public let goal: Goal
    public let leaderParts: [Parts]
    public let recruitStatus: [RecruitStatus]
    public var HashTags: [HashTag] = []

    public init(id: Int, title: String, thumbnail: String?, region: String, online: Bool, careerMin: String, careerMax: String, createdAt: String, state: String, favorite: Int, myFavorite: Bool, category: [String], goal: String, leaderParts: [Parts], recruitStatus: [RecruitStatus]) {
        self.id = id
        self.title = title
        self.thumbnail = thumbnail
        self.region = region
        
        if online == true {
            self.isOnline = .online
        } else if online == true && region != "미설정" {
            self.isOnline = .onOffline
        } else {
            self.isOnline = .offline
        }
        
        self.careerMin = Career.findCareer(string: careerMin)
        self.careerMax = Career.findCareer(string: careerMax)
        self.createdAt = createdAt
        self.state = ProjectState.findState(string: state)
        self.careerMin = Career.findCareer(string: careerMin)
        self.careerMax = Career.findCareer(string: careerMax)
        self.favorite = favorite
        self.myFavorite = myFavorite
        self.category = category
        self.goal = Goal.findCellStringToPurpose(string: goal)
        self.leaderParts = leaderParts
        self.recruitStatus = recruitStatus
        
        setHashTags()
    }
    
    mutating func setHashTags() {
        self.HashTags.append(HashTag(title: state.toString(), background: .pink, titleColor: .gray))
        self.HashTags.append(HashTag(title: "\(self.careerMin.toCellString())", background: .pink, titleColor: .gray))
        self.HashTags.append(HashTag(title: "\(self.goal.toCellString())", background: .gray, titleColor: .gray))
        category.forEach {
            self.HashTags.append(HashTag(title: $0, background: .gray, titleColor: .gray))
        }
    }
}

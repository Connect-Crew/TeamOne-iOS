//
//  Project.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Core

public struct Project {
    public let id: Int
    public let title: String
    public let banners: [String]
    public var region: String
    public let online: Bool
    public let createdAt, state, careerMin, careerMax: String
    public let category: [String]
    public let goal: String
    public let leader: Leader
    public let introduction: String
    public var favorite: Int
    public var myFavorite: Bool
    public let recruitStatus: [RecruitStatus]
    public let skills: [String]
    public var isMine: Bool
    public var isAppliable: Bool
    public var recruitTarget: Int
    public var recruitNow: Int

    public var hashTags: [HashTag] = []

    public init(id: Int, title: String, banners: [String], region: String, online: Bool, createdAt: String, state: String, careerMin: String, careerMax: String, category: [String], goal: String, leader: Leader, introduction: String, favorite: Int, myFavorite: Bool, recruitStatus: [RecruitStatus], skills: [String]) {
        self.id = id
        self.title = title
        self.banners = banners
        self.region = region
        self.online = online
        self.createdAt = createdAt
        self.state = state
        self.careerMin = careerMin
        self.careerMax = careerMax
        self.category = category
        self.goal = goal
        self.leader = leader
        self.introduction = introduction
        self.favorite = favorite
        self.myFavorite = myFavorite
        self.recruitStatus = recruitStatus
        self.skills = skills
        self.isMine = false
        self.isAppliable = true
        self.recruitNow = 0
        self.recruitTarget = 0

        for status in recruitStatus {
            self.recruitNow += status.current
            self.recruitTarget += status.max
        }

        if recruitNow >= recruitTarget {
            self.isAppliable = false
        }

        if let Myid = UserDefaultKeyList.User.id {
            if Myid == leader.id {
                self.isMine = true
            } else {
                self.isMine = false
            }
        } else {
            self.isMine = false
        }

        if online == true {
            self.region = "온라인"
        }



        self.hashTags.append(HashTag(title: state, background: .pink, titleColor: .gray))

        if careerMin == "경력무관" {
            self.hashTags.append(HashTag(title: "경력 무관", background: .pink, titleColor: .gray))
        } else {
            self.hashTags.append(HashTag(title: "\(careerMin) 차 이상", background: .pink, titleColor: .gray))
        }
        self.hashTags.append(HashTag(title: goal, background: .gray, titleColor: .gray))

        category.forEach {
            self.hashTags.append(HashTag(title: $0, background: .gray, titleColor: .gray))
        }
    }
    
    public static let noneInfoProject = Project(id: Int.max, title: "", banners: [], region: "", online: true, createdAt: "", state: "", careerMin: "", careerMax: "", category: [], goal: "", leader: Leader(id: Int.max, nickname: "", profile: "", introduction: "", temperature: 0.0, responseRate: 0, parts: [], representProjects: []), introduction: "", favorite: 0, myFavorite: false, recruitStatus: [], skills: [])
}

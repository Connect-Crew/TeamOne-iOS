//
//  Project.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Core
import UIKit

public struct Project {
    public let id: Int
    public let title: String
    public let banners: [String]
    public var region: String
    public let isOnline: isOnline
    public let createdAt: String
    public let state: ProjectState
    public let careerMin, careerMax: Career
    public let category: [String]
    public let goal: Goal
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
        
        if online == true {
            self.isOnline = .online
        } else if online == true && region != "미설정" {
            self.isOnline = .onOffline
        } else {
            self.isOnline = .offline
        }
        
        self.createdAt = createdAt
        self.state = ProjectState.findState(string: state)
        self.careerMin = Career.findCareer(string: careerMin)
        self.careerMax = Career.findCareer(string: careerMax)
        self.category = category
        self.goal = Goal.findCellStringToPurpose(string: goal)
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
    
    public static let noneInfoProject = Project(
        id: Int.max,
        title: "",
        banners: [],
        region: "",
        online: true,
        createdAt: "",
        state: ProjectState.before.toString(),
        careerMin: "경력무관",
        careerMax: "경력무관",
        category: [],
        goal: "NONE",
        leader: Leader(
            id: Int.max,
            nickname: "",
            profile: "",
            introduction: "",
            temperature: 0.0,
            responseRate: 0,
            parts: [],
            representProjects: []
        ),
        introduction: "", 
        favorite: 0,
        myFavorite: false,
        recruitStatus: [],
        skills: []
    )
    
    public func toProps() -> ProjectCreateProps {

        return ProjectCreateProps(
            banner: [],
            title: self.title,
            region: self.region,
            isOnline: self.isOnline,
            state: self.state,
            careerMin: self.careerMin,
            careerMax: self.careerMax,
            leaderParts: "리더파트정보필요",
            category: self.category,
            goal: self.goal,
            introducion: self.introduction,
            recruits: self.recruitStatus.map {
                return Recruit(part: $0.part, comment: $0.comment, max: $0.max)
            },
            skills: self.skills
        )
    }
}

//
//  MyProfile.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct Profile {

    public let id: Int
    public let nickname, profile, introduction: String
    public let temperature: Double
    public let responseRate: Int
    public let parts: [String]
    public let representProjects: [RepresentProject]

    public init(id: Int, nickname: String, profile: String, introduction: String, temperature: Double, responseRate: Int, parts: [String], representProjects: [RepresentProject]) {
        self.id = id
        self.nickname = nickname
        self.profile = profile
        self.introduction = introduction
        self.temperature = temperature
        self.responseRate = responseRate
        self.parts = parts
        self.representProjects = representProjects
    }
}

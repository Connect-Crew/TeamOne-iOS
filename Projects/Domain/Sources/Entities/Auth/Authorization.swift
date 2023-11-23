//
//  Authorization.swift
//  Domain
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct Authorization: Codable {
    public var id: Int
    public var nickname, profile, introduction: String
    public var temperature: Double
    public var responseRate: Int
    public var parts: [String]
    public var email, token, exp, refreshToken: String
    public var refreshExp: String

    public init(id: Int, nickname: String, profile: String, introduction: String, temperature: Double, responseRate: Int, parts: [String], email: String, token: String, exp: String, refreshToken: String, refreshExp: String) {
        self.id = id
        self.nickname = nickname
        self.profile = profile
        self.introduction = introduction
        self.temperature = temperature
        self.responseRate = responseRate
        self.parts = parts
        self.email = email
        self.token = token
        self.exp = exp
        self.refreshToken = refreshToken
        self.refreshExp = refreshExp
    }
}

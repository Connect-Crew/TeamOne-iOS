//
//  ProjectListRequestDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct ProjectListRequestDTO: Codable {
    let lastId: Int?
    let size: String
    let goal: String?
    let career: String?
    let region: String?
    let online: String?
    let part: String?
    let skills: String?
    let states: String?
    let category: String?
    let search: String?

    public init(lastId: Int?, size: String, goal: String?, career: String?, region: String?, online: String?, part: String?, skills: String?, states: String?, category: String?, search: String?) {
        self.lastId = lastId
        self.size = size
        self.goal = goal
        self.career = career
        self.region = region
        self.online = online
        self.part = part
        self.skills = skills
        self.states = states
        self.category = category
        self.search = search
    }
}

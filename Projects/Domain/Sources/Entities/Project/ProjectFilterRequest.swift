//
//  ProjectFilterRequest.swift
//  Domain
//
//  Created by Junyoung on 12/10/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct ProjectFilterRequest {
    let lastId: Int?
    let size: Int
    let goal: String?
    let career: String?
    let region: String?
    let online: String?
    let part: String?
    let skills: String?
    let states: String?
    let category: String?
    let search: String?
    
    public init(lastId: Int? = nil,
         size: Int,
         goal: String? = nil,
         career: String? = nil,
         region: String? = nil,
         online: String? = nil,
         part: String? = nil,
         skills: String? = nil,
         states: String? = nil,
         category: String? = nil,
         search: String? = nil) {
        
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

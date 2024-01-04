//
//  ProjectMember.swift
//  Domain
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct ProjectMember {
    var profile: Profile
    var isLeader: Bool
    var parts: [String]
    
    public init(profile: Profile, isLeader: Bool, parts: [String]) {
        self.profile = profile
        self.isLeader = isLeader
        self.parts = parts
    }
}

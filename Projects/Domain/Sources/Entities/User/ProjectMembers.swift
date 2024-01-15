//
//  ProjectMember.swift
//  Domain
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct ProjectMember: Hashable {
    
    public static func == (lhs: ProjectMember, rhs: ProjectMember) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    let identifier = UUID()
    
    public var profile: Profile
    public var isLeader: Bool
    public var parts: [String]
    
    public init(profile: Profile, isLeader: Bool, parts: [String]) {
        self.profile = profile
        self.isLeader = isLeader
        self.parts = parts
    }
}

//
//  ProjectCreateProps.swift
//  Domain
//
//  Created by 강현준 on 1/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit

public struct ProjectCreateProps {
    public var banner: [UIImage]
    public var title: String
    public var region: String
    public var online: isOnline
    public var state: ProjectState
    public var careerMin: Career
    public var careerMax: Career
    public var leaderParts: String
    public var category: [String]
    public var goal: Purpose
    public var introducion: String
    public var recruits: [Recurit]
    public var skills: [String]
    
    public init(banner: [UIImage], title: String, region: String, online: isOnline, state: ProjectState, careerMin: Career, careerMax: Career, leaderParts: String, category: [String], goal: Purpose, introducion: String, recruits: [Recurit], skills: [String]) {
        self.banner = banner
        self.title = title
        self.region = region
        self.online = online
        self.state = state
        self.careerMin = careerMin
        self.careerMax = careerMax
        self.leaderParts = leaderParts
        self.category = category
        self.goal = goal
        self.introducion = introducion
        self.recruits = recruits
        self.skills = skills
    }
}

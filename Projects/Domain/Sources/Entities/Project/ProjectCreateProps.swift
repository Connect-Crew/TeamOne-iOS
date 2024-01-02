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
    public var online: Bool
    public var state: String
    public var careerMin: String
    public var careerMax: String
    public var leaderParts: String
    public var category: [String]
    public var goal: String
    public var introducion: String
    public var recruits: [Recurit]
    public var skills: [String]
    
    public init(banner: [UIImage], title: String, region: String, online: Bool, state: String, careerMin: String, careerMax: String, leaderParts: String, category: [String], goal: String, introducion: String, recruits: [Recurit], skills: [String]) {
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

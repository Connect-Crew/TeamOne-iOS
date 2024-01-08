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
    public var banner: [UIImage] = []
    public var title: String? = nil
    public var region: String? = nil
    public var isOnline: isOnline? = nil
    public var state: ProjectState? = nil
    public var careerMin: Career? = nil
    public var careerMax: Career? = nil
    public var leaderParts: String? = nil
    public var category: [String] = []
    public var goal: Goal? = nil
    public var introducion: String? = nil
    public var recruits: [Recruit] = []
    public var skills: [String] = []
    
    public init(banner: [UIImage], title: String, region: String, isOnline: isOnline, state: ProjectState, careerMin: Career, careerMax: Career, leaderParts: String, category: [String], goal: Goal, introducion: String, recruits: [Recruit], skills: [String]) {
        self.banner = banner
        self.title = title
        self.region = region
        self.isOnline = isOnline
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
    
    public init() { }
}

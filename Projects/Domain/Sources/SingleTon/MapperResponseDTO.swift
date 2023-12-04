//
//  MapperResponseDTO.swift
//  Domain
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct BaseProjectInfoParameters {
    public let region: [Category]
    public let job: [Job]
    public let skill: [String]
    public let category: [Category]

    public init(region: [Category], job: [Job], skill: [String], category: [Category]) {
        self.region = region
        self.job = job
        self.skill = skill
        self.category = category
    }
}

// MARK: - Job
public struct Job {
    public let name, key: String
    public let value: [Category]

    public init(name: String, key: String, value: [Category]) {
        self.name = name
        self.key = key
        self.value = value
    }
}

// MARK: - Category
public struct Category {
    public let name, key: String

    public init(name: String, key: String) {
        self.name = name
        self.key = key
    }
}

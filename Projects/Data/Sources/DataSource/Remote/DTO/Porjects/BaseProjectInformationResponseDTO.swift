//
//  BaseProjectInformationResponseDTO.swift
//  Data
//
//  Created by 강현준 on 12/4/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct BaseProjectInformationResponseDTO: Codable {
    public let region: [CategoryResponseDTO]
    public let job: [JobResponseDTO]
    public let skill: [String]
    public let category: [CategoryResponseDTO]

    func toDomain() -> BaseProjectInfoParameters {
        return BaseProjectInfoParameters(
            region: region.map { $0.toDomain() },
            job: job.map { $0.toDomain() },
            skill: skill,
            category: category.map { $0.toDomain() }
        )
    }
}

// MARK: - Job
public struct JobResponseDTO: Codable {
    let name, key: String
    let value: [CategoryResponseDTO]

    func toDomain() -> Job {
        return Job(
            name: self.name,
            key: self.key,
            value: value.map { $0.toDomain() }
        )
    }
}

// MARK: - Category
public struct CategoryResponseDTO: Codable {
    let name, key: String

    func toDomain() -> Domain.Category {
        return Domain.Category(name: self.name, key: self.key)
    }
}

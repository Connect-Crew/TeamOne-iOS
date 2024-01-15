//
//  RecruitStatusResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/9/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

struct RecruitStatusResponseDTO: Codable {
    let containLeader: Bool
    let category: String
    let part: String
    let partKey: String
    let comment: String
    let current: Int
    let max: Int
    let applied: Bool?

    func toDomain() -> RecruitStatus {
        return RecruitStatus(
            category: self.category,
            part: self.part,
            partKey: self.partKey,
            comment: self.comment,
            current: self.current,
            max: self.max,
            applied: self.applied ?? false
        )
    }
}

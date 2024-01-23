//
//  RecruitStatus.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct RecruitStatus: Codable, Hashable {
    public let category: String
    public let part: String
    public let partKey: String
    public let comment: String
    public var current, max: Int
    public var applied: Bool
    public var isQuotaFull: Bool

    public init(category: String, part: String, partKey: String, comment: String, current: Int, max: Int, applied: Bool) {
        self.category = category
        self.part = part
        self.partKey = partKey
        self.comment = comment
        self.current = current
        self.max = max
        self.applied = applied

        self.isQuotaFull = current >= max ? true : false
    }
    
    public func toRecruit() -> Recruit {
        return Recruit(
            category: self.category,
            part: self.part,
            comment: self.comment,
            max: self.max
        )
    }
}

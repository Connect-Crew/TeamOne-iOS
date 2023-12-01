//
//  RecruitStatus.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct RecruitStatus: Codable {
    public let category, part, partKey, comment: String
    public let current, max: Int
    public var isAppliable: Bool
    public var applied: Bool

    public init(category: String, part: String, partKey: String, comment: String, current: Int, max: Int, applied: Bool) {
        self.category = category
        self.part = part
        self.partKey = partKey
        self.comment = comment
        self.current = current
        self.max = max
        self.applied = applied

        self.isAppliable = true

        if current >= max || applied == true{
            isAppliable = false
        }
    }
}

//
//  ApplicantsList.swift
//  Domain
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

/// 파트별 지원 정보를 나타냅니다.
public struct ApplyStatus {
    public let partKey: String
    public let part: String
    public let category: String
    public let applies: Int
    public let current: Int
    public let max: Int
    public let comment: String
    
    /// 모집 종료 여부를 나타냅니다
    public let isQuotaFull: Bool
    
    public init(partKey: String, applies: Int, current: Int, max: Int, comment: String) {
        self.partKey = partKey
        self.part = KM.shared.findNameByKey(key: partKey)
        self.category = KM.shared.findParentCategoryBySubKey(subKey: partKey).parentName
        self.applies = applies
        self.current = current
        self.max = max
        self.comment = comment
        self.isQuotaFull =  current >= max ? true : false
    }
    
}

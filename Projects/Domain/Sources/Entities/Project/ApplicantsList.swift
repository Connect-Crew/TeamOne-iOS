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
    public let applies: Int
    public let current: Int
    public let max: Int
    
    /// 모집 종료 여부를 나타냅니다
    public let isQuotaFull: Bool
    
    public init(partKey: String, applies: Int, current: Int, max: Int) {
        self.partKey = partKey
        self.applies = applies
        self.current = current
        self.max = max
        self.isQuotaFull =  current >= max ? true : false
    }
    
}

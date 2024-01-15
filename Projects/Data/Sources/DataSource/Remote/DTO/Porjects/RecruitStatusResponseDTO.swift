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
    var current: Int
    var max: Int
    let applied: Bool?

    public func toDomain() -> RecruitStatus {
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
    
    public func toDomain() -> Parts {
        return Parts(
            key: self.partKey,
            part: self.part,
            category: self.category
        )
    }
    
    public static func exceptLeaerPosition(status: [RecruitStatusResponseDTO]) -> [RecruitStatusResponseDTO] {
        
        let exceptLeaerRecruitStatus = status.filter { status in
            !(status.containLeader == true && status.max == 1)
        }.map { status in
            if status.containLeader == true && status.max > 1 {
                var modifiedStatus = status
                
                modifiedStatus.max -= 1
                modifiedStatus.current -= 1
                
                return modifiedStatus
            }
            
            return status
        }
        
        return exceptLeaerRecruitStatus
    }
}

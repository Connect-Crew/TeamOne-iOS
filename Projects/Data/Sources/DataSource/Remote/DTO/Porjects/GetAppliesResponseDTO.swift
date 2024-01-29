//
//  GetAppliesResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct GetAppliesResponseDTO: Codable {
    let id: Int
    let projectId: Int
    let user: BaseUserResponseDTO
    let part: String
    let message: String
    let contact: String?
    let state: String
    let leaderMessage: String?
    
    func toDomain() -> Applies {
        return Applies(
            id: self.id,
            projectId: self.projectId,
            user: self.user.toDomain(),
            part: self.part,
            message: self.message,
            contact: self.contact ?? "연락처 정보 없음",
            state: self.state,
            leaderMessage: self.leaderMessage
        )
    }
}


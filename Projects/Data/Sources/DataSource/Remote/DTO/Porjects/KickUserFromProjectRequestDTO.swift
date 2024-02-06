//
//  KickUserFromProjectRequestDTO.swift
//  Data
//
//  Created by 강현준 on 2/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct KickUserFromProjectRequestDTO: Codable {
    let project: Int
    let userId: Int
    let reasons: [KickReasonRequestDTO]
    
    public init(project: Int, userId: Int, reasons: [User_ExpelReason]) {
        self.project = project
        self.userId = userId
        self.reasons = reasons.map { KickReasonRequestDTO(type: $0.toRequestTypeString, reason: $0.toRequestReasonString) }
    }
    
    public struct KickReasonRequestDTO: Codable {
        let type: String
        let reason: String
        
        public init(type: String, reason: String) {
            self.type = type
            self.reason = reason
        }
    }
}

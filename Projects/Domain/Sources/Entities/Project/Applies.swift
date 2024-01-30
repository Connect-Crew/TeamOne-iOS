//
//  Applies.swift
//  Domain
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

/// 선택한 파트의 지원정보

public struct Applies {
    
    public enum AppliesState {
        case waiting
        case accept
        case reject
        
        public init(state: String) {
            if state == "WAITING" {
                self = .waiting
            } else if state == "ACCEPT" {
                self = .accept
            } else {
                self = .waiting
            }
        }
    }
        
    public let id: Int
    public let projectId: Int
    public let user: Profile
    public let part: String
    public let message: String
    public let contact: String
    public let state: AppliesState
    public let leaderMessage: String

    public init(id: Int, projectId: Int, user: Profile, part: String, message: String, contact: String, state: String, leaderMessage: String?) {
        self.id = id
        self.projectId = projectId
        self.user = user
        self.part = part
        self.message = message
        self.contact = contact
        self.state = .init(state: state)
        self.leaderMessage = leaderMessage ?? ""
    }
}

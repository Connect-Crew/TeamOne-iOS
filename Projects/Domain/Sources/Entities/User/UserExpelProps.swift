//
//  UserExpelProps.swift
//  Domain
//
//  Created by 강현준 on 1/15/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct UserExpelProps {
    var id: Project
    var willExpelMember: ProjectMember
    var reasons: [User_ExpelReason]
    
    public init(
        id: Project,
        willExpelMember: ProjectMember, 
        reasons: [User_ExpelReason]
    ) {
        self.id = id
        self.willExpelMember = willExpelMember
        self.reasons = reasons
    }
}

//
//  ProjectApplyRequestDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct ProjectApplyRequestDTO: Codable {
    let projectId: Int
    let part: String
    let message: String

    public init(projectId: Int, part: String, message: String) {
        self.projectId = projectId
        self.part = part
        self.message = message
    }
}

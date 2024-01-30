//
//  GetAppliesRequestDTO.swift
//  Data
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct GetAppliesRequestDTO: Codable {
    let projectId: Int
    let part: String
    
    public init(projectId: Int, part: String) {
        self.projectId = projectId
        self.part = part
    }
}

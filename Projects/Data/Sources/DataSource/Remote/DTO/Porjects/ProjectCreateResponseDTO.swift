//
//  ProjectCreateResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct ProjectCreateResponseDTO: Codable {
    let value: Int
    
    func toDomain() -> ProjectCreateResponse {
        return ProjectCreateResponse(value: self.value)
    }
}

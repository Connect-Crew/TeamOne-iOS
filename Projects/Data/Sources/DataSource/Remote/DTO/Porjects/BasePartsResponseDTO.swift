//
//  BasePartsResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/15/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct BasePartsResponseDTO: Codable {
    var key: String
    var part: String
    var category: String
    
    func toDomain() -> Parts {
        return Parts(
            key: self.key,
            part: self.part,
            category: self.category
        )
    }
}

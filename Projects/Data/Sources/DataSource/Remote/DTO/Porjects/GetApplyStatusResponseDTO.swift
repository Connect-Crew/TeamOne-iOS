//
//  GetApplyStatusResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain
import UIKit

public struct GetApplyStatusResponseDTO: Codable {
    let partKey: String
    let partDescription: String
    let partCategoryKey: String
    let partCategoryDescription: String
    let applies: Int
    let current: Int
    let max: Int
    let comment: String
    
    func toDomain() -> ApplyStatus {
        return ApplyStatus(
            partKey: self.partKey,
            partDescription: self.partDescription,
            partCategoryKey: self.partCategoryKey,
            partCategoryDescription: self.partCategoryDescription,
            applies: self.applies,
            current: self.current,
            max: self.max,
            comment: self.comment
        )
    }
}

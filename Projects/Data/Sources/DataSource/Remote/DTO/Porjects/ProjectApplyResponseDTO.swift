//
//  ProjectApplyResponseDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct ProjectApplyResponseDTO: Codable {
    let value: Bool

    func toDomain() -> Bool {
        return value
    }
}

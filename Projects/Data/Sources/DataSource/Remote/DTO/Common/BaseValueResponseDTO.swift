//
//  BaseValueResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct BaseValueResponseDTO: Codable {
    let value: Bool

    func toDomain() -> Bool {
        return value
    }
}

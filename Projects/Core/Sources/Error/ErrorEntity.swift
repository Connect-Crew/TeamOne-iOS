//
//  ErrorEntity.swift
//  Core
//
//  Created by 강현준 on 1/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct ErrorEntity: Codable {
    let timestamp: String
    let path: String
    let status: Int
    let error: String
    let message: String
}

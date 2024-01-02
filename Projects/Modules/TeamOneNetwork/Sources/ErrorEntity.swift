//
//  ErrorEntity.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct ErrorEntity: Codable {
    let timestamp: String
    let path: String
    let status: Int
    let error: String
    let message: String
}

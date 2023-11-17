//
//  ErrorResponse.swift
//  Domain
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable {
    let timestamp: String
    let path: String
    let status: Int
    let error: String
    let message: String

    public init(timestamp: String, path: String, status: Int, error: String, message: String) {
        self.timestamp = timestamp
        self.path = path
        self.status = status
        self.error = error
        self.message = message
    }
}

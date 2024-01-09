//
//  APIError.swift
//  Core
//
//  Created by 강현준 on 1/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public enum APIError: Error, Equatable {
    case network(statusCode: Int, message: String)
    case notToken
    case unknown

    public init(error: ErrorEntity) {
        self = .network(statusCode: error.status, message: error.error)
    }
}

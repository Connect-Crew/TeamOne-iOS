//
//  APIError.swift
//  Network
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum APIError: Error, Equatable {
    case network(statusCode: Int, message: String)
    case notToken
    case unknown

    init(error: ErrorEntity) {
        self = .network(statusCode: error.status, message: error.message)
    }
}

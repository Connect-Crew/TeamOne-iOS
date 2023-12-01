//
//  APIError.swift
//  Network
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum APIError: Error, Equatable {
    case network(statusCode: Int)
    case unknown
    case tokenReissuanceFailed

    init(error: Error, statusCode: Int? = 0) {
        guard let statusCode else { self = .unknown ; return }
        self = .network(statusCode: statusCode)
    }
}

//
//  APIError.swift
//  Core
//
//  Created by 강현준 on 1/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public enum APIError: Error, Equatable , LocalizedError{
    case network(statusCode: Int, message: String)
    case notToken
    case decodingError
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .network(let statusCode, let message):
            return "ErrorCode: \(statusCode)\nmessage: \(message)"
        case .notToken:
            return "유저 토큰이 없습니다. 로그아웃됩니다."
        case .decodingError:
            return "디코딩 에러 발생"
        case .unknown:
            return "알 수 없는 에러"
        }
    }

    public init(error: ErrorEntity) {
        self = .network(statusCode: error.status, message: error.message)
    }
}

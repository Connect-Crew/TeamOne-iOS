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
    case notConnectedToInternet
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .network(let statusCode, let message):
            return "ErrorCode: \(statusCode)\nmessage: \(message)"
        case .notToken:
            return "유저 토큰이 없습니다. 로그아웃됩니다."
        case .decodingError:
            return "디코딩 에러 발생"
        case .notConnectedToInternet: 
            return "네트워크 연결 문제가 발생했습니다."
        case .unknown:
            return "알 수 없는 에러"
        }
    }

    public init(error: ErrorEntity) {
        
        if error.status == 401 {
            self = .notToken
        } else {
            self = .network(statusCode: error.status, message: error.message)
        }
    }
}

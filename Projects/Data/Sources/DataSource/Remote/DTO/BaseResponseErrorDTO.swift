//
//  BaseResponseErrorDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct BaseResponseErrorDTO: Decodable {
    let timestamp: String
    let path: String
    let status: Int
    let error: String
    let message: String

    func toDoamin() -> ErrorResponse {
        return ErrorResponse(
            timestamp: self.timestamp,
            path: self.path,
            status: self.status,
            error: self.error,
            message: self.message
        )
    }
}

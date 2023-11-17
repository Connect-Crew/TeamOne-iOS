//
//  AuthRefreshResponseDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct AuthRefreshResponseDTO: Codable {
    public let token: String
    public let exp: String

    func toDomain() -> RefreshToken {
        return RefreshToken(token: token, exp: exp)
    }
}

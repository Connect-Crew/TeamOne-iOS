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
    public let refresh: String
    public let refreshExp: String

    func toDomain() -> RefreshToken {
        return RefreshToken(
            token: self.token,
            exp: self.exp,
            refresh: self.refresh,
            refreshExp: self.refreshExp
        )
    }
}

//
//  AuthRegisterResponseDTO.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct AuthResponseResponseDTO: Decodable {
    let id: Int
    let nickname: String
    let profile: String?
    let introducion: String?
    let temperature: Double
    let responseRate: Int
    let parts: [BasePartsResponseDTO]
    let email: String?
    let token: String
    let exp: String
    let refreshToken: String
    let refreshExp: String

    func toDomain() -> Authorization {
        return Authorization(
            id: self.id,
            nickname: self.nickname,
            profile: self.profile ?? "",
            introduction: self.introducion ?? "",
            temperature: self.temperature,
            responseRate: self.responseRate,
            parts: self.parts.map { $0.toDomain() },
            email: self.email ?? "",
            token: self.token,
            exp: self.exp,
            refreshToken: self.refreshToken,
            refreshExp: self.refreshExp
        )
    }
}

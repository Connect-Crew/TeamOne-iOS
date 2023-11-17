//
//  AuthRegisterRequestDTO.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct AuthRegisterRequestDTO: Encodable {
    let token: String
    let social: String
    let username: String?
    let nickname: String
    let profile: String? = nil
    let email: String?
    let termsAgreement: Bool
    let privacyAgreement: Bool

    public init(token: String, social: String, username: String?, nickname: String, email: String?, termsAgreement: Bool, privacyAgreement: Bool) {
        self.token = token
        self.social = social
        self.username = username
        self.nickname = nickname
        self.email = email
        self.termsAgreement = termsAgreement
        self.privacyAgreement = privacyAgreement
    }
}

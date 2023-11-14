//
//  Authorization.swift
//  Domain
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct Authorization {
    let accessToken: String
    let refreshToken: String
    let idToken: String?

    public init(accessToken: String, refreshToken: String, idToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.idToken = idToken
    }
}

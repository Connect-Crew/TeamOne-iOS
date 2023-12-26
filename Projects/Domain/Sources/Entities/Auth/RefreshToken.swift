//
//  RefreshToken.swift
//  Domain
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct RefreshToken {
    public let token: String
    public let exp: String
    public let refresh: String
    public let refreshExp: String

    public init(token: String, exp: String, refresh: String, refreshExp: String) {
        self.token = token
        self.exp = exp
        self.refresh = refresh
        self.refreshExp = refreshExp
    }
}

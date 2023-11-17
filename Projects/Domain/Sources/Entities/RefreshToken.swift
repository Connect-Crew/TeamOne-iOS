//
//  RefreshToken.swift
//  Domain
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct RefreshToken {
    let token: String
    let exp: String

    public init(token: String, exp: String) {
        self.token = token
        self.exp = exp
    }
}

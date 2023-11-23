//
//  OAuthLoginProps.swift
//  Domain
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct OAuthLoginProps {
    public let token: String
    public let social: Social

    public init(token: String, social: Social) {
        self.token = token
        self.social = social
    }
}

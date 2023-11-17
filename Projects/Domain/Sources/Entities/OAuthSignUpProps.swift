//
//  UserAuthorization.swift
//  Domain
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct OAuthSignUpProps {
    public var token: String
    public var social: Social
    public var username: String?
    public var profileImage: String?
    public var nickName: String
    public var email: String?

    public init(token: String, social: Social, username: String?, profileImage: String?, nickName: String, email: String?) {
        self.token = token
        self.social = social
        self.username = username
        self.profileImage = profileImage
        self.nickName = nickName
        self.email = email
    }
}

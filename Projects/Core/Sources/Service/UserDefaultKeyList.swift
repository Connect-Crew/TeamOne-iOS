//
//  UserDefaultKeyList.swift
//  Core
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct UserDefaultKeyList {
    public struct Auth {
        @UserDefaultWrapper<String>(key: "appAccessToken") public static var appAccessToken
        @UserDefaultWrapper<String>(key: "appRefreshToken") public static var appRefreshToken
        @UserDefaultWrapper<String>(key: "appLoginSocial") public static var appLoginSocial
        @UserDefaultWrapper<String>(key: "APNsToken") public static var APNsToken
    }
}

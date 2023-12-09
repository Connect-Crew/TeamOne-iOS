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

    public struct User {
        @UserDefaultWrapper<Int>(key: "id") public static var id
        @UserDefaultWrapper<String>(key: "nickname") public static var nickname
        @UserDefaultWrapper<String>(key: "profileImageURL") public static var profileImageURL
        @UserDefaultWrapper<String>(key: "introduction") public static var introduction
        @UserDefaultWrapper<Double>(key: "temperature") public static var temperature
        @UserDefaultWrapper<Int>(key: "responseRate") public static var responseRate
        @UserDefaultWrapper<[String]>(key: "parts") public static var parts
    }
    
    public struct RecentSearchHistory {
        @UserDefaultWrapper<[String]>(key: "searchRecentHistory") public static var searchRecentHistory
    }
}

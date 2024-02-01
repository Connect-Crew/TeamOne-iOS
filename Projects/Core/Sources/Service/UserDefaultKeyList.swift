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
    }
    
    public struct RecentSearchHistory {
        @UserDefaultWrapper<[String]>(key: "searchRecentHistory") public static var searchRecentHistory
    }
    
    public struct Setting {
        public struct Notification {
            @UserDefaultWrapper<Bool>(key: "activity") public static var activity
        }
    }
}

extension UserDefaultKeyList {
    public static func clearAllUserData() {
        UserDefaultKeyList.Auth.appAccessToken = nil
        UserDefaultKeyList.Auth.appRefreshToken = nil
        UserDefaultKeyList.Auth.appLoginSocial = nil
        UserDefaultKeyList.User.id = nil
        UserDefaultKeyList.User.nickname = nil
        UserDefaultKeyList.User.profileImageURL = nil
        UserDefaultKeyList.User.introduction = nil
        UserDefaultKeyList.User.temperature = nil
        UserDefaultKeyList.User.responseRate = nil
        UserDefaultKeyList.RecentSearchHistory.searchRecentHistory = nil
    }
    
    public static func clearAllSetting() {
        UserDefaultKeyList.Setting.Notification.activity = nil
    }
}

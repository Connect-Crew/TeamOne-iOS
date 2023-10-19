//
//  InfoPlists.swift
//  EnvPlugin
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription

public extension Project {
    static let appInfoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "0.1.0",
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "CFBundleIdentifier": "com.connectCrew.TeamOne",
        "CFBundleDisplayName": "TeamOne",
        "UILaunchStoryboardName": "Launch Screen",
        "UIUserInterfaceStyle": "Light",
        "UIRequiresFullScreen": true,
        "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
        "ITSAppUsesNonExemptEncryption": false,
        "NSMicrophoneUsageDescription": "마이크 권한 설정",
        "NSCameraUsageDescription": "카메라 권한 설정",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],

        // 824892478094-oo9loraifcq96hg9lkmf1rs65fgschi9.apps.googleusercontent.com
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "kakao",
                "CFBundleURLSchemes": ["kakaof846269cfc5b4132aeeb49a24a15db78"]
            ]
        ],
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLName": "google",
                "CFBundleURLSchemes": ["com.googleusercontent.apps.824892478094-oo9loraifcq96hg9lkmf1rs65fgschi9"]
            ]
        ],
        "UIBackgroundModes": ["remote-notification"],
        "LSApplicationQueriesSchemes": [
            "kakaompassauth",
            "kakaolink"
        ]
    ]
}

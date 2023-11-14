//
//  AppDelegate.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/09.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import DSKit
import RxKakaoSDKCommon
import KakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        #if DEV
        print("Develop")
        #else
        print("Product")
        #endif

        RxKakaoSDK.initSDK(appKey: AppKey.kakaoNativeAppKey)

        // 폰트생성

        Fonts.fontInitialize()

        // 의존성 생성

        registerDependencies()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // 카카오 로그인 관련
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.rx.handleOpenUrl(url: url)
        }

        return false
    }
}

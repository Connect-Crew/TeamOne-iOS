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
import Firebase
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let notificationCenter = UNUserNotificationCenter.current()
    let notificationOption: UNAuthorizationOptions = [.alert, .badge, .sound]

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        #if DEV
        print("Develop")
        #else
        print("Product")
        #endif

        RxKakaoSDK.initSDK(appKey: AppKey.kakaoNativeAppKey)
        FirebaseApp.configure()

        // 폰트생성

        Fonts.fontInitialize()

        // 의존성 생성

        registerDependencies()

        // APNs

        notificationCenter.delegate = self
        registerForPushNotivications()
        application.registerForRemoteNotifications()

        // FCM

        Messaging.messaging().delegate = self
        
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
        } else {
            return GIDSignIn.sharedInstance.handle(url)
        }
    }

    func registerForPushNotivications() {
        notificationCenter.requestAuthorization(
            options: notificationOption, completionHandler: { granted, error in

                if let error = error {
                    print("DEBUG: \(error)")
                }

                if granted {
                    print("권한 허용 여부 \(granted)")
                }
            }
        )
    }
}

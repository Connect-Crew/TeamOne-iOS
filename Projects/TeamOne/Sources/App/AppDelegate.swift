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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        #if DEV
        print("Develop")
        #else
        print("Product")
        #endif

        // 의존성 생성

        registerDependencies()

        // 폰트생성

        Fonts.fontInitialize()
        
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
}

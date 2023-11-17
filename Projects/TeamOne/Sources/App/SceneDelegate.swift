//
//  SceneDelegate.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/09.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxKakaoSDKAuth
import KakaoSDKAuth
import GoogleSignIn

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    let disposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        appCoordinator = AppCoordinator(window)

        appCoordinator?.start()
            .subscribe()
            .disposed(by: disposeBag)
        
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            // 카카오 로그인 관련
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            } else {
                _ = GIDSignIn.sharedInstance.handle(url)
            }
        }
    }
}

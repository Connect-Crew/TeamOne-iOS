//
//  LoginViewModel.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import AuthenticationServices

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Core

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

enum LoginNavigation {
    case finish
    case getToken(String, Social)
}

final class LoginMainViewModel: ViewModel {

    struct Input {
        let kakaoLoginTap: Observable<Void>
        let googleLoginTap: Observable<Void>
        let appleLoginTap: Observable<Void>
    }
    
    struct Output {
        
    }
    
    let navigation = PublishSubject<LoginNavigation>()
    var disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {

        input.appleLoginTap
            .flatMap {
                ASAuthorizationAppleIDProvider().rx.login(scope: [.email])
            }
            .map { result -> String in

                guard let auth = result.credential as? ASAuthorizationAppleIDCredential,
                      let token = auth.identityToken,
                      let tokenString = String(data: token, encoding: .utf8) else { assert(true); return "" }

                print("발급받은 토큰 token: \(tokenString)")

                return tokenString
            }
            .map { LoginNavigation.getToken($0, .apple) }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        return Output()
    }
}

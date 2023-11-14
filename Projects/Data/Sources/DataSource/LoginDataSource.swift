//
//  LoginDataSource.swift
//  Data
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

enum LoginError: Error {
    case kakaoUnAvailable
}

public protocol LoginDataSourceProtocol {
    func getKakaoToken() -> Single<OAuthToken>
}

public final class LoginDataSource: LoginDataSourceProtocol {

    var disposeBag = DisposeBag()

    public init() { }

    public func getKakaoToken() -> Single<OAuthToken> {
        return Single.create { single in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { token in
                        single(.success(token))
                    }, onError: { error in
                        single(.failure(error))
                    })
                    .disposed(by: self.disposeBag) // DisposeBag에 추가하여 메모리 누수 방지
            } else {
                single(.failure(LoginError.kakaoUnAvailable))
            }
            return Disposables.create()
        }
    }
}

//
//  LoginViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/10.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import AuthenticationServices

import UIKit
import Foundation
import RxSwift
import RxCocoa
import Core

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import GoogleSignIn

import Domain

enum LoginNavigation {
    case finish
    case getToken(OAuthSignUpProps)
}

final class LoginMainViewModel: ViewModel {

    let loginUseCase: LoginUseCaseProtocol

    weak var viewController: UIViewController?

    public init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }

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
                ASAuthorizationAppleIDProvider().rx.login(scope: [.email, .fullName])
                    .catch { _ in return .empty() }
            }
            .map { result -> (token: String, name: String?, email: String?) in

                guard let auth = result.credential as? ASAuthorizationAppleIDCredential,
                      let token = auth.identityToken,
                      let tokenString = String(data: token, encoding: .utf8) else {
                    print("AuthError!!!")
                    return (token: "", name: "", email: "")
                }

                let email = auth.email ?? ""
                let name = auth.fullName

                var nameString: String = ""

                if let name = auth.fullName {
                    let nameFormatter = PersonNameComponentsFormatter()
                    nameString = nameFormatter.string(from: name)
                }

                print("발급받은 토큰 token: \(tokenString)")
                print("유저 네임 = \(nameString)")
                print("유저 email: \(email)")

                return (token: tokenString, name: nameString, email: email)
            }
            .withUnretained(self)
            .flatMap { viewModel, data in
                viewModel.loginUseCase.login(props: OAuthLoginProps(token: data.token, social: .apple))
                    .map { result in
                        if result == true {
                            return LoginNavigation.finish
                        } else {
                            return LoginNavigation.getToken(OAuthSignUpProps(
                                token: data.token,
                                social: .apple,
                                username: data.name,
                                email: data.email))
                        }
                    }
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.kakaoLoginTap
            .flatMap {
                UserApi.isKakaoTalkLoginAvailable() ?
                UserApi.shared.rx.loginWithKakaoTalk()
                    .catch { _ in return .empty() } :
                UserApi.shared.rx.loginWithKakaoAccount()
                    .catch { _ in return .empty() }
            }
            .catch({ error -> Observable<OAuthToken> in
                    print("로그인 실패 또는 취소: \(error)")
                    return .empty()
                })
            .map { oAuthToken -> (token: String, name: String?, email: String?) in

                print("발급받은 토큰 token in kakao: \(oAuthToken.accessToken)")

                return (token: oAuthToken.accessToken, name: nil, email: nil)
            }
            .withUnretained(self)
            .flatMap { viewModel, data in
                viewModel.loginUseCase.login(
                    props: OAuthLoginProps(
                        token: data.token,
                        social: .kakao
                    )
                )
                .map { result in
                    print("!!!!!!!!!!!KAKAOLOGINRESULT")
                    print(result)
                    print("!!!!!!!!!!!!")
                    if result == true {
                        return LoginNavigation.finish
                    } else {
                        return LoginNavigation.getToken(OAuthSignUpProps(
                            token: data.token,
                            social: .kakao,
                            username: data.name,
                            email: data.email))
                    }
                }
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.googleLoginTap
            .withUnretained(self)
            .subscribe(onNext: { viewModel, _ in

                guard let viewController = viewModel.viewController else { return  }

                let config = GIDConfiguration(clientID: AppKey.googleClientID)

                GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController) { result, error in
                    if let result = result {
                        let accessToken = result.authentication.accessToken
                        let name = result.profile?.name
                        let email = result.profile?.email

                        print("DEBUG: GOOGLE SignIn Result !!!! \n accessToken: \(accessToken)\n name: \(name)\n email: \(email)")

                        viewModel.loginUseCase.login(props: OAuthLoginProps(token: accessToken, social: .google))
                            .map {
                                print("!!!!!!!!!!! GOOGLE SignIn RESULT")
                                print(result)
                                print("!!!!!!!!!!!!")

                                if $0 == true {
                                    return LoginNavigation.finish
                                } else {
                                    return LoginNavigation.getToken(OAuthSignUpProps(
                                        token: accessToken,
                                        social: .google,
                                        username: name,
                                        email: email))
                                }
                            }
                            .subscribe(onSuccess: {
                                viewModel.navigation.onNext($0)
                            })
                            .disposed(by: viewModel.disposeBag)
                    }

                    if error != nil {
                        print()
                        print("DEBUG: GOOGLE Signin Error \(error)")
                        print()
                    }
                }
            })
            .disposed(by: disposeBag)

        return Output()
    }
}

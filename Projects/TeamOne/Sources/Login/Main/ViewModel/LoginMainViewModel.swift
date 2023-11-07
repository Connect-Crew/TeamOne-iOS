//
//  LoginViewModel.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

enum LoginNavigation {
    case finish
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

        input
            .kakaoLoginTap
            .subscribe(onNext: {
                if UserApi.isKakaoTalkLoginAvailable() {
                    UserApi.shared.rx.loginWithKakaoAccount()
                        .subscribe(onNext: { (oauthToken) in
                            print("loginWithKakaoTalk() success.")

                            print(oauthToken)

                        })
                
                }
            })
            .disposed(by: disposeBag)

        return Output()
    }

}

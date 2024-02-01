//
//  SetNickNameViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Core
import Domain

import RxSwift
import RxCocoa
import Data

enum SetNickNameNavigation {
    case finish
    case back
    case close
}

final class SetNickNameViewModel: ViewModel {

    var auth: OAuthSignUpProps? = nil

    let signUpUseCase: SignUpUseCaseProtocol

    public init(signUpUseCase: SignUpUseCaseProtocol) {
        self.signUpUseCase = signUpUseCase
    }
    
    struct Input {
        let nickname: Observable<String>
        let clearButtonTapped: Observable<Void>
        let registeredButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
        let closeButtonTapped: Observable<Void>
    }

    struct Output {
        let isEnabled: Driver<Bool>
        let errorText: Driver<String>
    }

    let navigation = PublishSubject<SetNickNameNavigation>()
    var disposeBag: DisposeBag = .init()

    let isEnabled = BehaviorSubject<Bool>(value: false)
    let errorText = BehaviorSubject<String>(value: "")

    func transform(input: Input) -> Output {

        input.nickname
            .withUnretained(self)
            .subscribe(onNext: { this, nickname in

                if nickname.count >= 2 && this.validate(nickName: nickname) {
                    this.isEnabled.onNext(true)
                    this.errorText.onNext("")
                } else {
                    if nickname.count < 2 {
                        this.errorText.onNext("닉네임은 2글자 이상이어야합니다.")
                        this.isEnabled.onNext(false)
                    } else if this.validate(nickName: nickname) == false || nickname.contains(" ") {
                        this.errorText.onNext("공백과 특수문자는 들어갈 수 없어요.")
                        this.isEnabled.onNext(false)
                    }
                }
            })
            .disposed(by: disposeBag)

        input.clearButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.isEnabled.onNext(false)
                self?.errorText.onNext("")
            })
            .disposed(by: disposeBag)

        input.registeredButtonTapped
            .withLatestFrom(input.nickname)
            .map { nickname in
                guard var auth = self.auth else { fatalError() }
                auth.nickName = nickname

                return auth
            }
            .withUnretained(self)
            .flatMap { this, auth in
                self.signUpUseCase.signUp(signUpProps: auth)
                    .catch { error in
                        
                        if let error = error as? APIError {
                            switch error {
                            case .network(_, let message):
                                this.errorText.onNext(message)
                                return .never()
                            default:
                                return .never()
                            }
                        }
                        
                        return .never()
                    }
            }
            .subscribe(onNext: { bool in
                if bool { self.navigation.onNext(.finish) }
            })
            .disposed(by: disposeBag)

        input.backButtonTapped
            .map { SetNickNameNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.closeButtonTapped
            .map { SetNickNameNavigation.close }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        return Output(
            isEnabled: isEnabled.asDriver(onErrorJustReturn: false),
            errorText: errorText.asDriver(onErrorJustReturn: "")
        )
    }

    private func validate(nickName: String) -> Bool {
        let regex = "^[a-zA-Z0-9가-힣]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: nickName)
    }
}

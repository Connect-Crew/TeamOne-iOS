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
            .subscribe(onNext: { [weak self] nickname in

                if nickname.count < 2 {
                    self?.isEnabled.onNext(false)
                    self?.errorText.onNext("")
                } else {
                    if let result = self?.validate(nickName: nickname) {
                        if result {
                            self?.isEnabled.onNext(true)
                            self?.errorText.onNext("")
                        } else {
                            self?.isEnabled.onNext(false)
                            self?.errorText.onNext("특수문자는 포함될 수 없어요")
                        }
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
            .flatMap {
                self.signUpUseCase.signUp(signUpProps: $0)
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

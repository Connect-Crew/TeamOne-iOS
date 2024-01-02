//
//  SplashMainViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/06.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Core
import Domain

enum SplashNavigation {
    case autoLogin
    case finish
}

final class SplashViewModel: ViewModel {

    let autoLoginUseCase: AutoLoginUseCaseProtocol

    public init(autoLoginUseCase: AutoLoginUseCaseProtocol) {
        self.autoLoginUseCase = autoLoginUseCase
    }

    struct Input {
        let viewDidAppear: Observable<Void>
    }

    struct Output {

    }

    let navigation = PublishSubject<SplashNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        input.viewDidAppear
            .withUnretained(self)
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .flatMap { $0.0.autoLoginUseCase.autoLogin() }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.navigation.onNext(.autoLogin)
            },
            onError: { [weak self] _ in
                self?.navigation.onNext(.finish)
            })
            .disposed(by: disposeBag)

        return Output()
    }
}

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
            .flatMap { $0.0.autoLoginUseCase.autoLogin().asResult()}
            .delay(.seconds(2), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success(let bool):
                    if bool { viewModel.navigation.onNext(.autoLogin) }
                    else { viewModel.navigation.onNext(.finish) }

                case .failure(let error):
                    print("DEBUG: SplashError \(error) ====> \(error.localizedDescription)")
                    viewModel.navigation.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)

        return Output()
    }
}

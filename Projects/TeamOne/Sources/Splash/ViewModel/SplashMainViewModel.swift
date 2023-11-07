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

    struct Input {
        let viewDidAppear: Observable<Void>
    }

    struct Output {

    }

    let navigation = PublishSubject<SplashNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        input.viewDidAppear
            .delay(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .map { .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        return Output()
    }
}

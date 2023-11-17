//
//  SignUpResultViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Core
import RxSwift
import RxCocoa

enum SingUpResultViewModelResult {
    case finish
}

final class SignUpResultViewModel: ViewModel {

    struct Input {
        let startButtonTap: Observable<Void>
    }

    struct Output {

    }

    let navigation = PublishSubject<SingUpResultViewModelResult>()

    var disposeBag: DisposeBag = .init()

    func transform(input: Input) -> Output {

        input.startButtonTap
            .map { .finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        return Output()
    }
}


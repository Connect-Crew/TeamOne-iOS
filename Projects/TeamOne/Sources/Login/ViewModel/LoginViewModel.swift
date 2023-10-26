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

enum LoginNavigation {

}

final class LoginViewModel: ViewModel {

    struct Input {

    }

    struct Output {

    }

    let navigation = PublishSubject<LoginNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        return Output()
    }
}

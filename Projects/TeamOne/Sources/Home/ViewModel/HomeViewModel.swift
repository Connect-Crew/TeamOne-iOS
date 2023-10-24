//
//  HomeViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

import Core

enum HomeNavigation {

}

final class HomeViewModel: ViewModel {

    struct Input {

    }

    struct Output {

    }

    let navigation = PublishSubject<HomeNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        return Output()
    }
}

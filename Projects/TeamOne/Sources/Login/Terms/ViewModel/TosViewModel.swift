//
//  TosViewModel.swift
//  TeamOne
//
//  Created by 임재현 on 2023/11/06.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core

enum TosNavigation {

}

final class TosViewModel: ViewModel {

    let token = BehaviorSubject<String>(value: "")
    let social = BehaviorSubject<Social>(value: .apple)

    let allSelected = BehaviorSubject<Bool>(value: false)
    let serviceTermSelected = BehaviorSubject<Bool>(value: false)
    let personalInfoPolycy = BehaviorSubject<Bool>(value: false)
    
    struct Input {
        let allSelected: Observable<Void>
        let serviceTermSelected: Observable<Void>
        let personalInfoPolycy: Observable<Void>
    }

    struct Output {
        let allSelected: Driver<Bool>
        let serviceTermSelected: Driver<Bool>
        let personalInfoPolycy: Driver<Bool>
    }

    let navigation = PublishSubject<TosNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        input.allSelected
            .withLatestFrom(allSelected)
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: allSelected)
            .disposed(by: disposeBag)

        return Output(
            allSelected: allSelected.asDriver(onErrorJustReturn: false),
            serviceTermSelected: serviceTermSelected.asDriver(onErrorJustReturn: false),
            personalInfoPolycy: personalInfoPolycy.asDriver(onErrorJustReturn: false)
        )
    }
}

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
import Domain
import UIKit

enum TosNavigation {
    case finish(OAuthSignUpProps)
    case close
    case back
}

final class TosViewModel: ViewModel {

    var auth: OAuthSignUpProps? = nil

    let allSelected = BehaviorSubject<Bool>(value: false)
    let serviceTermSelected = BehaviorSubject<Bool>(value: false)
    let personalInfoPolycy = BehaviorSubject<Bool>(value: false)
    
    struct Input {
        let allSelected: Observable<Void>
        let serviceTermSelected: Observable<Void>
        let personalInfoPolycy: Observable<Void>
        let nextButtonTap: Observable<Void>
        let backButtonTap: Observable<Void>
        let closeButtonTap: Observable<Void>
        let goToServiceTerms: Observable<Void>
        let gotoPersonalInfoPolicy: Observable<Void>
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
            .map { !$0 }
            .bind(to: allSelected)
            .disposed(by: disposeBag)

        input.personalInfoPolycy
            .withLatestFrom(personalInfoPolycy)
            .map { !$0 }
            .bind(to: personalInfoPolycy)
            .disposed(by: disposeBag)

        input.serviceTermSelected
            .withLatestFrom(serviceTermSelected)
            .map { !$0 }
            .bind(to: serviceTermSelected)
            .disposed(by: disposeBag)

        input.nextButtonTap
            .withUnretained(self)
            .map { viewModel, _ in
                guard let auth = viewModel.auth else { fatalError() }

                return TosNavigation.finish(auth)
            }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.backButtonTap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.closeButtonTap
            .map { .close }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        Observable.combineLatest(personalInfoPolycy, serviceTermSelected)
            .map {
                if $0.0 == true && $0.1 == true {
                    return true
                } else {
                    return false
                }
            }
            .bind(to: allSelected)
            .disposed(by: disposeBag)

        input.allSelected
            .withLatestFrom(allSelected)
            .subscribe(onNext: { [weak self] in
                self?.serviceTermSelected.onNext($0)
                self?.personalInfoPolycy.onNext($0)
                self?.allSelected.onNext($0)
            })
            .disposed(by: disposeBag)

        input.goToServiceTerms
            .subscribe(onNext: {
                if let url = URL(string: "https://hong-cho.notion.site/TEAM-no-1-70f007a62fdf4f8db5321115b09ff2ec") {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)

        input.gotoPersonalInfoPolicy
            .subscribe(onNext: {
                if let url = URL(string: "https://hong-cho.notion.site/TEAM-no-1-70f007a62fdf4f8db5321115b09ff2ec") {
                    UIApplication.shared.open(url)
                }
            })
            .disposed(by: disposeBag)

        return Output(
            allSelected: allSelected.asDriver(onErrorJustReturn: false),
            serviceTermSelected: serviceTermSelected.asDriver(onErrorJustReturn: false),
            personalInfoPolycy: personalInfoPolycy.asDriver(onErrorJustReturn: false)
        )
    }
}

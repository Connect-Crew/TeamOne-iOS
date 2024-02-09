//
//  DropoutViewModel.swift
//  TeamOne
//
//  Created by 강창혁 on 2/7/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import Domain
import RxSwift
import RxCocoa
import Core

enum DropoutNavigation {
    case finish
    case back
}

final class DropoutViewModel: ViewModel {
    
    private let noProjectIsSeleted = BehaviorSubject<Bool>(value: false)
    private let noUserIsSeleted = BehaviorSubject<Bool>(value: false)
    private let noTeamIsSeleted = BehaviorSubject<Bool>(value: false)
    private let noMannerIsSeleted = BehaviorSubject<Bool>(value: false)
    private let newAccountIsSeleted = BehaviorSubject<Bool>(value: false)
    private let etcIsSeleted = BehaviorSubject<Bool>(value: false)
    private let etcText = BehaviorSubject<String>(value: "")
    
    struct Input {
        let tapBack: Observable<Void>
        let noProjectCheck: Observable<Void>
        let noUserCheck: Observable<Void>
        let noTeamMemberCheck: Observable<Void>
        let noMannerCheck: Observable<Void>
        let newAccountCheck: Observable<Void>
        let etcCheck: Observable<Void>
        let etcText: Observable<String>
        let dropoutResult: PublishSubject<Bool>
    }
    
    struct Output {
        let noProjectIsSeleted: Driver<Bool>
        let noUserIsSeleted: Driver<Bool>
        let noTeamIsSeleted: Driver<Bool>
        let noMannerIsSeleted: Driver<Bool>
        let newAccountIsSeleted: Driver<Bool>
        let etcIsSeleted: Driver<Bool>
        let etcTextFieldIshidden: Driver<Bool>
        let etcDescriptionLabelIshidden: Driver<Bool>
        let underLineColorChanged: Driver<Bool>
        let isEnabled: Driver<Bool>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<DropoutNavigation>()
    
    func transform(input: Input) -> Output {
        
        input.tapBack
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.navigation.onNext(.back)
            })
            .disposed(by: disposeBag)
        
        input.noProjectCheck
            .withLatestFrom(noProjectIsSeleted)
            .map { !$0 }
            .bind(to: noProjectIsSeleted)
            .disposed(by: disposeBag)
        
        input.noTeamMemberCheck
            .withLatestFrom(noTeamIsSeleted)
            .map { !$0 }
            .bind(to: noTeamIsSeleted)
            .disposed(by: disposeBag)
        
        input.noUserCheck
            .withLatestFrom(noUserIsSeleted)
            .map { !$0 }
            .bind(to: noUserIsSeleted)
            .disposed(by: disposeBag)
        
        input.noMannerCheck
            .withLatestFrom(noMannerIsSeleted)
            .map { !$0 }
            .bind(to: noMannerIsSeleted)
            .disposed(by: disposeBag)
        
        input.newAccountCheck
            .withLatestFrom(newAccountIsSeleted)
            .map { !$0 }
            .bind(to: newAccountIsSeleted)
            .disposed(by: disposeBag)
        
        input.etcCheck
            .withLatestFrom(etcIsSeleted)
            .map { !$0 }
            .bind(to: etcIsSeleted)
            .disposed(by: disposeBag)
        
        input.etcText
            .bind(to: etcText)
            .disposed(by: disposeBag)
        
        let etcTextIsEmpty = etcText.map { $0.isEmpty }
        let etcDescriptionLabelIshidden = etcTextIsEmpty.map { !$0 }.asDriver(onErrorJustReturn: false)
        let underLineColorChanged = etcTextIsEmpty.asDriver(onErrorJustReturn: false)
        let etcTextFieldIshidden = etcIsSeleted
            .map { !$0 }
            .asDriver(onErrorJustReturn: false)
        
        let isEnabled = Observable.combineLatest(
            noProjectIsSeleted,
            noUserIsSeleted,
            noTeamIsSeleted,
            noMannerIsSeleted,
            newAccountIsSeleted,
            etcIsSeleted,
            etcText
        ).map {
            if $5 == true {
                return $6.isEmpty ? false : true
            } else {
                return $0 || $1 || $2 || $3 || $4
            }
        }.asDriver(onErrorJustReturn: false)
        
        input.dropoutResult
            .withUnretained(self)
            .bind(onNext: { this, success in
                if success {
                    this.navigation.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)
        
        return Output(
            noProjectIsSeleted: noProjectIsSeleted.asDriver(onErrorJustReturn: false),
            noUserIsSeleted: noUserIsSeleted.asDriver(onErrorJustReturn: false),
            noTeamIsSeleted: noTeamIsSeleted.asDriver(onErrorJustReturn: false),
            noMannerIsSeleted: noMannerIsSeleted.asDriver(onErrorJustReturn: false),
            newAccountIsSeleted: newAccountIsSeleted.asDriver(onErrorJustReturn: false),
            etcIsSeleted: etcIsSeleted.asDriver(onErrorJustReturn: false),
            etcTextFieldIshidden: etcTextFieldIshidden,
            etcDescriptionLabelIshidden: etcDescriptionLabelIshidden,
            underLineColorChanged: underLineColorChanged,
            isEnabled: isEnabled
        )
    }
    
}

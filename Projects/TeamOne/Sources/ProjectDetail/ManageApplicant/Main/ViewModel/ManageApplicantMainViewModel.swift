//
//  ManageApplicantViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum ManageApplicantNavigation {
    case back
    case detail(projectId: Int, status: ApplyStatus)
}

final class ManageApplicantMainViewModel: ViewModel {
    
    let getApplyStatusUseCase: GetApplyStatusUseCase
    
    public init(
        projectId: Int,
        getApplyStatusUseCase: GetApplyStatusUseCase
    ) {
        self.projectId = BehaviorRelay<Int>(value: projectId)
        self.getApplyStatusUseCase = getApplyStatusUseCase
    }
    
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let backButtonTap: PublishRelay<Void>
        let didSelectCell: Observable<IndexPath>
    }
    
    struct Output {
        let applyStatusList: Driver<[ApplyStatus]>
        let noHandleError: Signal<Error>
    }
    
    var disposeBag: DisposeBag = .init()
    
    let navigation = PublishSubject<ManageApplicantNavigation>()
    
    let projectId: BehaviorRelay<Int>
    let applyStatusList = BehaviorRelay<[ApplyStatus]>(value: [])
    let noHandleError = PublishRelay<Error>()
    
    func transform(input: Input) -> Output {
        
        transformRecruit()
        transformBackButton(backButtonTap: input.backButtonTap)
        transformToDtail(didSelectCell: input.didSelectCell)
        
        return Output(
            applyStatusList: applyStatusList.asDriver(),
            noHandleError: noHandleError.asSignal()
        )
    }
    
    private func transformRecruit() {
        
        projectId
            .withUnretained(self)
            .flatMap { this, id in
                this.getApplyStatusUseCase.getApplyStatus(projectId: id)
            }
            .bind(to: applyStatusList)
            .disposed(by: disposeBag)
        
    }
    
    private func transformToDtail(didSelectCell: Observable<IndexPath>) {
        didSelectCell
            .withLatestFrom(applyStatusList) { indexPath, status in
                return status[indexPath.row]
            }
            .withLatestFrom(projectId) { status, id in
                return (id: id, status: status)
            }
            .withUnretained(self)
            .subscribe(onNext: { this, args in
                
                let id = args.id
                let status = args.status
                
                this.navigation.onNext(.detail(projectId: id, status: status))
            })
            .disposed(by: disposeBag)
    }
    
    private func transformBackButton(backButtonTap: PublishRelay<Void>) {
        backButtonTap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}


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
    case detail(project: Project, status: RecruitStatus)
}

final class ManageApplicantMainViewModel: ViewModel {
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let backButtonTap: PublishRelay<Void>
        let didSelectCell: Observable<IndexPath>
    }
    
    struct Output {
        let recruitStatus: Driver<[RecruitStatus]>
        let noHandleError: Signal<Error>
    }
    
    var disposeBag: DisposeBag = .init()
    
    let navigation = PublishSubject<ManageApplicantNavigation>()
    
    let getApplyStatusUseCase: GetApplyStatusUseCase
    
    let project: BehaviorRelay<Project>
    let recruitStatus = BehaviorRelay<[RecruitStatus]>(value: [])
    let noHandleError = PublishRelay<Error>()
    
    public init(
        project: Project,
        getApplyStatusUseCase: GetApplyStatusUseCase
    ) {
        self.project = BehaviorRelay<Project>(value: project)
        self.getApplyStatusUseCase = getApplyStatusUseCase
    }
    
    func transform(input: Input) -> Output {
        
        transformBackButton(backButtonTap: input.backButtonTap)
        transformRecruit()
        transformToDtail(didSelectCell: input.didSelectCell)
        
        return Output(
            recruitStatus: recruitStatus.asDriver(),
            noHandleError: noHandleError.asSignal()
        )
    }
    
    func transformRecruit() {
        project
            .map { $0.recruitStatus }
            .bind(to: recruitStatus)
            .disposed(by: disposeBag)
    }
    
    func transformToDtail(didSelectCell: Observable<IndexPath>) {
        didSelectCell
            .withLatestFrom(recruitStatus) { indexPath, status in
                return status[indexPath.row]
            }
            .withLatestFrom(project) { status, project in
                return (project, status)
            }
            .withUnretained(self)
            .subscribe(onNext: { this, args in
                
                let project = args.0
                let status = args.1
                
                this.navigation.onNext(.detail(project: project, status: status))
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


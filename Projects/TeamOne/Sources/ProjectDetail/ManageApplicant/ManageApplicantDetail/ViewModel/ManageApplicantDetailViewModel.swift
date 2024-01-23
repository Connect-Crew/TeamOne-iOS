//
//  ManageApplicantDetailViewModel.swift
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

enum ManageApplicantDetailNavigation {
    case back
}

final class ManageApplicantDetailViewModel: ViewModel {
    
//    public init(
//        status: RecruitStatus,
//        project: Project
//    ) {
//        self.status = BehaviorRelay<RecruitStatus>(value: status)
//        self.project = BehaviorRelay<Project>(value: project)
//    }
    
    struct Input {
        let backButtonTap: PublishRelay<Void>
//        let rejectButtonTap: Observable<Void>
//        let approveButtonTap: Observable<Void>
    }
    
    struct Output {
        // 디테일 정보가 들어온 경우
        let sampleOutput: Driver<[Int]>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ManageApplicantDetailNavigation>()
    
//    let status: BehaviorRelay<RecruitStatus>
//    let project: BehaviorRelay<Project>
    
    func transform(input: Input) -> Output {
        
        transformBackButton(backButtonTap: input.backButtonTap)
        
        return Output(
            sampleOutput: Observable.just([1, 2, 3, 4, 5]).asDriver(onErrorJustReturn: [])
        )
    }
    
    func transformBackButton(backButtonTap: PublishRelay<Void>) {
        backButtonTap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}


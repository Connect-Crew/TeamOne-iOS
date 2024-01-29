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
    
    // MARK: - 프로필 나오기 전 임시
    
    let getAppliesUseCase = DIContainer.shared.resolve(GetAppliesUseCase.self)
    let approveUserUseCase = DIContainer.shared.resolve(ApproveUserUseCase.self)
    let rejectUserUseCase = DIContainer.shared.resolve(RejectUserUseCase.self)
    
    public init(
        status: ApplyStatus,
        projectId: Int
    ) {
        self.status = BehaviorRelay<ApplyStatus>(value: status)
        self.projectId = BehaviorRelay<Int>(value: projectId)
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let backButtonTap: PublishRelay<Void>
        /// First param is row, second is rejectMessage
        let rejectButtonTap: PublishRelay<(Int, String)>
        /// First param is row
        let approveButtonTap: PublishRelay<Int>
    }
    
    struct Output {
        let status: Driver<ApplyStatus>
        let appliesList: Driver<[Applies]>
        let error: Signal<Error>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<ManageApplicantDetailNavigation>()
    
    let refresh = PublishRelay<Void>()
    let status: BehaviorRelay<ApplyStatus>
    let projectId: BehaviorRelay<Int>
    let appliesList = BehaviorRelay<[Applies]>(value: [])
    let error = PublishRelay<Error>()
    
    func transform(input: Input) -> Output {
        
        trasnformList(viewDidLoad: input.viewDidLoad)
        transformBackButton(backButtonTap: input.backButtonTap)
        transformApprove(row: input.approveButtonTap)
        transformReject(reject: input.rejectButtonTap)
        
        return Output(
            status: status.asDriver(),
            appliesList: appliesList.asDriver(),
            error: error.asSignal()
        )
    }
    
    private func trasnformList(viewDidLoad: Observable<Void>) {
        Observable.merge(
            viewDidLoad,
            refresh.asObservable()
        )
        .withLatestFrom(Observable.combineLatest(projectId, status))
        .withUnretained(self)
        .flatMap { this, args in
            let projectId = args.0
            let status = args.1
            return this.getAppliesUseCase.getApplies(projectId: projectId, part: status.partKey)
                .asObservable()
                .catch { error in
                    this.error.accept(error)
                    return .empty()
                }
        }
        .bind(to: appliesList)
        .disposed(by: disposeBag)
    }
    
    private func transformBackButton(backButtonTap: PublishRelay<Void>) {
        backButtonTap
            .map { .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    private func transformApprove(row: PublishRelay<Int>) {
        row
            .withLatestFrom(appliesList) { row, list in
                return list[row]
            }
            .withUnretained(self)
            .flatMap { this, target in
                this.approveUserUseCase.approve(applyId: target.id)
                    .asObservable()
                    .catch { error in
                        
                        this.error.accept(error)
                        
                        return .empty()
                    }
            }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.refresh.accept(())
                ProjectDetailCoordinator.refresh.onNext(())
            })
            .disposed(by: disposeBag)
    }
    
    private func transformReject(reject: PublishRelay<(Int, String)>) {
        reject
            .withLatestFrom(appliesList) { rejectProps, list in
                let row = rejectProps.0
                let message = rejectProps.1
                
                return (id: list[row].id, message: message)
            }
            .withUnretained(self)
            .flatMap { (this, tuple) in
                
                let id = tuple.id
                let messge = tuple.message
                
                return this.rejectUserUseCase.reject(applyId: tuple.id, rejectMessage: messge)
                    .asObservable()
                    .catch { error in
                        this.error.accept(error)
                        
                        return .empty()
                    }
            }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.refresh.accept(())
            })
            .disposed(by: disposeBag)
    }
}


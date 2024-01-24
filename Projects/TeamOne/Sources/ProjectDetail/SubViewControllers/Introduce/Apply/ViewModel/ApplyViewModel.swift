//
//  ApplyBottomSheetViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Domain
import Core
import TeamOneNetwork
import DSKit

enum ApplyNavigation {
    case close
}

final class ApplyViewModel: ViewModel {

    let applyUseCase: ProjectApplyUseCaseProtocol
    let projectUseCase: ProjectInfoUseCase

    init(project: Project,
         applyUseCase: ProjectApplyUseCaseProtocol,
         projectUseCase: ProjectInfoUseCase) {
        self.project = BehaviorRelay<Project>(value: project)
        self.applyUseCase = applyUseCase
        self.projectUseCase = projectUseCase
    }

    struct Input {
        let close: Observable<Void>
        let applyPartTap: Observable<RecruitStatus>
        let applicationText: Observable<String>
        let contact: Observable<String>
        let applyButtonTap: Observable<Void>
    }

    struct Output {
        let project: Driver<Project>
        let showWriteApplication: PublishSubject<RecruitStatus>
        let showResult: Signal<Bool>
        let error: Signal<Error>
    }

    let navigation = PublishSubject<ApplyNavigation>()
    
    // MARK: - Alert
    
    // MARK: - Subject

    let project: BehaviorRelay<Project>
    let selectPart = PublishSubject<RecruitStatus>()
    let refresh = PublishSubject<Void>()
    let showResult = PublishSubject<Bool>()
    let error = PublishRelay<Error>()
    
    var disposeBag: DisposeBag = .init()

    func transform(input: Input) -> Output {

        input.close
            .map { .close }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.applyPartTap
            .bind(to: selectPart)
            .disposed(by: disposeBag)

        input.applyButtonTap
            .withLatestFrom(
                Observable.combineLatest(
                    project,
                    selectPart.asObservable(),
                    input.applicationText,
                    input.contact
                )
            )
            .map {
                return (id: $0.0.id, part: $0.1.part, message: $0.2, contact: $0.3)
            }
            .withUnretained(self)
            .flatMap { viewModel, args in
                viewModel.applyUseCase.apply(projectId: args.id, part: KM.shared.key(name: args.part), message: args.message, contact: args.contact)
                    .catch { error in
                        viewModel.error.accept(error)
                        return .just(false)
                    }
            }
            .filter { $0 == true }
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.showResult.onNext(true)
            })
            .disposed(by: disposeBag)

        return Output(
            project: project.asDriver(),
            showWriteApplication: selectPart,
            showResult: showResult.asSignal(onErrorJustReturn: false),
            error: error.asSignal()
        )
    }
}

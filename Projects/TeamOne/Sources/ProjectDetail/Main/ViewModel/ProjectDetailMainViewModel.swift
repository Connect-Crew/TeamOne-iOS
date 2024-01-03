//
//  ProjectDetailMainViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Core
import Domain
import RxSwift
import RxCocoa

enum ProjectDetailMainNavigation {
    case back
}

enum ProjectIsMine {
    case mine
    case other
}

final class ProjectDetailMainViewModel: ViewModel {

    struct Input {
        let viewWillAppear: Observable<Void>
        let backButtonTap: Observable<Void>
//        let reportButtonTap: Observable<Void
    }

    struct Output {
        let isMyProject: Driver<Bool>
    }

    var project: Project!

    let projectUseCase: ProjectUseCaseProtocol

    public init(projectUseCase: ProjectUseCaseProtocol) {
        self.projectUseCase = projectUseCase
    }

    let type = BehaviorSubject<ProjectIsMine>(value: .other)

    let navigation = PublishSubject<ProjectDetailMainNavigation>()

    var disposeBag: DisposeBag = .init()

    func transform(input: Input) -> Output {

        input.viewWillAppear
            .map { self.projectUseCase.isMyProject(project: self.project) }
            .subscribe(onNext: {
                if $0 == true {
                    self.type.onNext(.mine)
                } else {
                    self.type.onNext(.other)
                }
            })
            .disposed(by: disposeBag)

        input.backButtonTap
            .map{ .back }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        return Output(
            isMyProject: type.map { $0 == .mine }.asDriver(onErrorJustReturn: false)
        )
    }
}


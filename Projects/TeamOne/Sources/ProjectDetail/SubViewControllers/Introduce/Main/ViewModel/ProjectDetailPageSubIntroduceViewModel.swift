//
//  ProjectDetailPageSubIntroduceViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa
import Domain
import Core

enum ProjectDetailPageSubIntroduceNavigation {
    case apply(Project)
}

final class ProjectDetailPageSubIntroduceViewModel: ViewModel {

    let projectLikeUseCase: ProjectLikeUseCaseProtocol
    let projectUseCase: ProjectUseCaseProtocol

    public init(projectLikeUseCase: ProjectLikeUseCaseProtocol, projectUseCase: ProjectUseCaseProtocol) {
        self.projectLikeUseCase = projectLikeUseCase
        self.projectUseCase = projectUseCase
    }

    struct Input {
        let likeButtonTap: Observable<Void>
        let applyButtonTap: Observable<Void>
    }

    struct Output {
        let project: Driver<Project?>
    }

    let reload = PublishSubject<Void>()
    let navigation = PublishSubject<ProjectDetailPageSubIntroduceNavigation>()

    let project = BehaviorSubject<Project?>(value: nil)

    var disposeBag: DisposeBag = .init()

    func transform(input: Input) -> Output {

        reload
            .withLatestFrom(project.compactMap { $0 })
            .withUnretained(self)
            .flatMap { viewModel, project in
                return viewModel.projectUseCase.project(projectId: project.id)
            }
            .bind(to: project)
            .disposed(by: disposeBag)

        input.applyButtonTap
            .withLatestFrom(project)
            .compactMap { $0 }
            .map { .apply($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)

        input.likeButtonTap
            .withLatestFrom(project)
            .compactMap { $0 }
            .withUnretained(self)
            .flatMap { viewModel, project in
                return viewModel.projectLikeUseCase.like(projectId: project.id)
                    .withLatestFrom(viewModel.project) { like, project in
                        var newProject = project

                        if like.project == project?.id {
                            newProject?.favorite = like.favorite
                            newProject?.myFavorite = like.myFavorite
                        }

                        return newProject
                    }
            }
            .bind(to: project)
            .disposed(by: disposeBag)

        return Output(
            project: project.asDriver(onErrorJustReturn: nil)
        )
    }
}


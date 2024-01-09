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
    case manageProject(Project)
}

final class ProjectDetailPageSubIntroduceViewModel: ViewModel {

    let projectLikeUseCase: ProjectLikeUseCaseProtocol
    let projectUseCase: ProjectInfoUseCase

    public init(projectLikeUseCase: ProjectLikeUseCaseProtocol, projectUseCase: ProjectInfoUseCase) {
        self.projectLikeUseCase = projectLikeUseCase
        self.projectUseCase = projectUseCase
    }

    struct Input {
        let likeButtonTap: Observable<Void>
        let applyButtonTap: Observable<Void>
        let manageButtonTap: Observable<Void>
    }

    struct Output {
        let project: Driver<Project?>
        let isMyproject: Driver<Bool>
    }

    let reload = PublishSubject<Void>()
    let navigation = PublishSubject<ProjectDetailPageSubIntroduceNavigation>()

    let project = BehaviorSubject<Project?>(value: nil)
    let isMyproject = BehaviorSubject<Bool>(value: false)

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
        
        project
            .map { $0?.isMine }
            .compactMap { $0 }
            .bind(to: isMyproject)
            .disposed(by: disposeBag)
        
        transformNavigation(input: input)
        transformLike(input: input)

        return Output(
            project: project.asDriver(onErrorJustReturn: nil),
            isMyproject: isMyproject.asDriver(onErrorJustReturn: false)
        )
    }
    
    func transformLike(input: Input) {
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
    }
    
    func transformNavigation(input: Input) {
        
        input.manageButtonTap
            .withLatestFrom(project)
            .compactMap { $0 }
            .map{
                print("!!!!!!!!!!!\(self)::::")
                print($0)
                print("!!!!!!!!!!!!")
                return ProjectDetailPageSubIntroduceNavigation.manageProject($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.applyButtonTap
            .withLatestFrom(project)
            .compactMap { $0 }
            .map { .apply($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}


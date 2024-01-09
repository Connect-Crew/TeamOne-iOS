//
//  HomeViewModel.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

import Core
import Domain


enum HomeNavigation {
    case write
    case participants(SideProjectListElement?)
    case detail(Project)
    case search
}

final class HomeViewModel: ViewModel {

    let projectListUseCase: ProjectListUseCaseProtocol
    let projectLikeUseCase: ProjectLikeUseCaseProtocol
    let myProfileUseCase: MyProfileUseCaseProtocol
    let projectUseCase: ProjectInfoUseCase

    public init(projectListUseCase: ProjectListUseCaseProtocol, projectLikeUseCase: ProjectLikeUseCaseProtocol, myProfileUseCase: MyProfileUseCaseProtocol, projectUseCase: ProjectInfoUseCase) {
        self.projectListUseCase = projectListUseCase
        self.projectLikeUseCase = projectLikeUseCase
        self.myProfileUseCase = myProfileUseCase
        self.projectUseCase = projectUseCase
    }

    struct Input {
        let viewDidLoad: Observable<Void>
        let parts: BehaviorRelay<String?>
        let writeButtonTap: Observable<Void>
        let participantsButtonTap: Observable<SideProjectListElement?>
        let likeButtonTap: Observable<SideProjectListElement?>
        let didScrolledEnd: Observable<Void>
        let didSelectedCell: Observable<IndexPath>
        let tapSearch: Observable<Void>
    }

    struct Output {
        let projects: Driver<[SideProjectListElement]>
        let error: PublishRelay<Error>
    }

    lazy var projects = BehaviorSubject<[SideProjectListElement]>(value: [])

    let isEmpty = BehaviorSubject<Bool>(value: false)
    let isEnd = BehaviorSubject<Bool>(value: false)
    let lastID = BehaviorSubject<Int?>(value: nil)

    let navigation = PublishSubject<HomeNavigation>()
    var disposeBag = DisposeBag()
    var error = PublishRelay<Error>()
    
    var refresh = PublishSubject<Void>()
    // 하위 코디네이터에서 프로젝트의 정보가 변경된 경우 변경된 사항을 반영하기위한 서브젝트
    var projectChangedSubject = PublishSubject<Project>()

    func transform(input: Input) -> Output {

        transformMyProfile(input: input)
        transformInputButton(input: input)
        transformLoadProjects(input: input)
        transformParticipantsButton(input: input)
        transformLikeButton(input: input)
        transformDidSelectCell(input: input)
        tarsfromMoveToSearch(input: input)
        transformChanged(input: input)
        
        return Output(
            projects: projects.asDriver(onErrorJustReturn: []),
            error: error
        )
    }
    
    func tarsfromMoveToSearch(input: Input) {
        input.tapSearch
            .map { .search }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }

    func transformMyProfile(input: Input) {
        input.viewDidLoad
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.myProfileUseCase.myProfile().asResult()
            }.subscribe(onNext: { _ in

            })
            .disposed(by: disposeBag)
    }

    func transformLoadProjects(input: Input) {

        input.parts
            .distinctUntilChanged()
            .map { [weak self] in
                self?.isEmpty.onNext(false)
                self?.lastID.onNext(nil)
                self?.isEnd.onNext(false)
                return $0
            }
            .withLatestFrom(
                Observable.combineLatest(lastID.asObservable(), input.parts)
            )
            .withUnretained(self)
            .flatMapLatest { viewModel, params in
                return viewModel.projectListUseCase.list(lastId: params.0, size: 30, goal: nil,
                                                         career: nil, region: nil, online: nil,
                                                         part: params.1, skills: nil, states: nil,
                                                         category: nil, search: nil)
                    .withLatestFrom(viewModel.projects) { newProjects, currentProjects in
                        return [] + newProjects
                    }
            }
            .subscribe(onNext: { [weak self] updateProjects in
                self?.projects.onNext(updateProjects)
                self?.lastID.onNext(updateProjects.last?.id)

                if updateProjects.isEmpty {
                    self?.isEmpty.onNext(true)
                } else {
                    self?.isEmpty.onNext(false)
                }

                if updateProjects.count < 30 {
                    self?.isEnd.onNext(true)
                }
            })
            .disposed(by: disposeBag)

        input
            .didScrolledEnd
            .withLatestFrom(isEnd)
            .filter { $0 == false }
            .withLatestFrom(
                Observable.combineLatest(lastID.asObservable(), input.parts)
            )
            .withUnretained(self)
            .flatMap { viewModel, params in
                return viewModel.projectListUseCase.list(
                    lastId: params.0,
                    size: 30, goal: nil,
                    career: nil, region: nil,
                    online: nil, part: params.1,
                    skills: nil, states: nil,
                    category: nil, search: nil)
                    .withLatestFrom(viewModel.projects) { new, current in
                        
                        if new.count < 30 {
                            viewModel.isEnd.onNext(true)
                        }

                        return current + new
                    }
            }
            .subscribe(onNext: { [weak self] updatedProjects in
                self?.projects.onNext(updatedProjects)
                self?.lastID.onNext(updatedProjects.last?.id)
            })
            .disposed(by: disposeBag)

    }

    func transformParticipantsButton(input: Input) {
        input.participantsButtonTap
            .map { .participants($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }

    func transformLikeButton(input: Input) {

        input.likeButtonTap
            .compactMap { $0 }
            .withUnretained(self)
            .flatMap { viewModel, project in
                return viewModel.projectLikeUseCase.like(projectId: project.id)
                    .catch { error in
                        
                        viewModel.error.accept(error)
                        
                        return .empty()
                    }
                    .withLatestFrom(viewModel.projects) { like, projects in

                        var newProject = projects

                        if let index = newProject.firstIndex(where: { $0.id == like.project
                        }) {
                            newProject[index].favorite = like.favorite
                            newProject[index].myFavorite = like.myFavorite
                        }
                        
                        return newProject
                    }
            }
            .bind(to: projects)
            .disposed(by: disposeBag)
    }

    func transformInputButton(input: Input) {
        input.writeButtonTap
            .map { .write }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }

    func transformDidSelectCell(input: Input) {
        input.didSelectedCell
            .withLatestFrom(projects) { indexPath, projects in
                return projects[indexPath.row]
            }
            .withUnretained(self)
            .flatMap { viewModel, project in
                viewModel.projectUseCase.project(projectId: project.id)
                    .catch { error in
                        viewModel.error.accept(error)
                        return .empty()
                    }
            }
            .map { HomeNavigation.detail($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
    
    func transformChanged(input: Input) {
        projectChangedSubject
            .withLatestFrom(projects) { changed, current in
                
                var newProjects = current
                
                if let index = newProjects.firstIndex(where: { $0.id == changed.id }) {
                    newProjects[index] = changed.toListElement()
                }
                
                return newProjects
            }
            .bind(to: projects)
            .disposed(by: disposeBag)
    }
}

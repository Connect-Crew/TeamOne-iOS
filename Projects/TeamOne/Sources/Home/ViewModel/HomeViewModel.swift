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
}

final class HomeViewModel: ViewModel {

    let projectListUseCase: ProjectListUseCaseProtocol
    let projectLikeUseCase: ProjectLikeUseCaseProtocol

    public init(projectListUseCase: ProjectListUseCaseProtocol,
                projectLikeUseCase: ProjectLikeUseCaseProtocol) {
        self.projectListUseCase = projectListUseCase
        self.projectLikeUseCase = projectLikeUseCase
    }

    // MARK: - Mocks

    struct Input {
        let parts: BehaviorRelay<String?>
        let writeButtonTap: Observable<Void>
        let participantsButtonTap: Observable<SideProjectListElement?>
        let likeButtonTap: Observable<SideProjectListElement?>
        let didScrolledEnd: Observable<Void>
    }

    struct Output {
        let projects: Driver<[SideProjectListElement]>
        let isEmpty: Driver<Bool>
    }

    lazy var projects = BehaviorSubject<[SideProjectListElement]>(value: [])

    let isEmpty = BehaviorSubject<Bool>(value: false)
    let isEnd = BehaviorSubject<Bool>(value: false)
    let lastID = BehaviorSubject<Int?>(value: nil)

    let navigation = PublishSubject<HomeNavigation>()
    var disposeBag = DisposeBag()

    func transform(input: Input) -> Output {

        transformInputButton(input: input)
        transformParts(input: input)
        transformParticipantsButton(input: input)
        transformLikeButton(input: input)

        return Output(
            projects: projects.asDriver(onErrorJustReturn: []),
            isEmpty: isEmpty.asDriver(onErrorJustReturn: true)
        )
    }

    func transformParts(input: Input) {
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
                        return newProjects
                    }
                    .map { newData in
                        return newData.sorted {

                            guard let first = $0.createdAt.toDate(),
                                  let second = $1.createdAt.toDate() else { return true }

                            return first < second
                        }
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
                return viewModel.projectListUseCase.list(lastId: params.0, size: 30, goal: nil,
                                                         career: nil, region: nil, online: nil,
                                                         part: params.1, skills: nil, states: nil,
                                                         category: nil, search: nil)
                    .withLatestFrom(viewModel.projects) { new, current in
                        if new.count < 30 {
                            viewModel.isEnd.onNext(true)
                        }
                        let sortedNew = new.sorted {
                            guard let first = $0.createdAt.toDate(),
                                  let second = $1.createdAt.toDate() else { return true }

                            return first < second
                        }

                        return current + sortedNew
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
                    .withLatestFrom(viewModel.projects) { like, projects in

                        var newProject = projects

                        if let index = projects.firstIndex(where: { $0.id == like.project
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
}

//
//  SearchViewModel.swift
//  TeamOne
//
//  Created by Junyoung on 12/5/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum SearchNavigation {
    case finish
    case toProject(Project)
    case participants(SideProjectListElement?)
}

final class SearchViewModel: ViewModel {
    
    private let recentHistoryFacade = DIContainer.shared.resolve(RecentHistoryFacade.self)
    
    private let projectListUseCase = DIContainer.shared.resolve(ProjectListUseCaseProtocol.self)
    private let projectUseCase = DIContainer.shared.resolve(ProjectUseCaseProtocol.self)
    private let projectLikeUseCase = DIContainer.shared.resolve(ProjectLikeUseCaseProtocol.self)
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchHistoryInput: Observable<String>
        let tapSearch: Observable<Void>
        let tapDeleteHistory: Observable<String>
        let tapClearAllHistory: Observable<Void>
        let tapBack: Observable<Void>
        let tapKeyword: Observable<String>
        let tapProject: Observable<SideProjectListElement>
        let participantsButtonTap: Observable<SideProjectListElement?>
        let likeButtonTap: Observable<SideProjectListElement?>
    }
    
    struct Output {
        let searchHistoryList: PublishRelay<[String]>
        let searchIsEmpty: PublishRelay<Bool>
        let searchResult: PublishRelay<[SideProjectListElement]>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<SearchNavigation>()
    
    func transform(input: Input) -> Output {
        
        let searchHistoryList = PublishRelay<[String]>()
        let searchIsEmpty = PublishRelay<Bool>()
        let searchResult = PublishRelay<[SideProjectListElement]>()
        
        searchResult
            .debug()
            .subscribe()
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                let historyList = this.recentHistoryFacade.getHistory()
                searchHistoryList.accept(historyList)
            })
            .disposed(by: disposeBag)
        
        // MARK: 검색 이벤트
        Observable.merge([
            input.tapKeyword,
            input.tapSearch.withLatestFrom(input.searchHistoryInput)
        ])
        .withUnretained(self)
        .subscribe(onNext: { this, text in
            this.recentHistoryFacade.saveHistroy(text)
        })
        .disposed(by: disposeBag)
        
        // MARK: 최근 검색 삭제
        input.tapDeleteHistory
            .withUnretained(self)
            .subscribe(onNext: { this, keyword in
                this.recentHistoryFacade.removeHistroy(keyword)
            })
            .disposed(by: disposeBag)
        
        // MARK: 최근 검색 전부 삭제
        input.tapClearAllHistory
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.recentHistoryFacade.removeAllHistory()
            })
            .disposed(by: disposeBag)
        
        // MARK: 삭제 및 검색 이벤트 이후 검색 목록 리프레시
        Observable.merge([input.tapDeleteHistory.map { _ in },
                          input.tapClearAllHistory
        ])
        .withUnretained(self)
        .subscribe(onNext: { this, _ in
            let historyList = this.recentHistoryFacade.getHistory()
            searchHistoryList.accept(historyList)
        })
        .disposed(by: disposeBag)
        
        // MARK: 뒤로가기
        input.tapBack
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.navigation.onNext(.finish)
            })
            .disposed(by: disposeBag)
        
        // MARK: 검색
        Observable.merge([
            input.tapKeyword,
            input.tapSearch.withLatestFrom(input.searchHistoryInput)
        ])
        .withUnretained(self)
        .flatMap({ this, keyword in
            this.projectListUseCase.projectList(request: ProjectFilterRequest(size: 30, search: keyword))
        })
        .filter {
            if $0.isEmpty {
                searchIsEmpty.accept(true)
                return false
            } else {
                searchIsEmpty.accept(false)
                return true
            }
        }
        .bind(to: searchResult)
        .disposed(by: disposeBag)
        
        // MARK: 프로젝트 선택
        input.tapProject
            .withUnretained(self)
            .flatMap { this, project -> Observable<Project> in
                this.projectUseCase.project(projectId: project.id)
            }
            .map { SearchNavigation.toProject($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.likeButtonTap
            .compactMap { $0 }
            .withUnretained(self)
            .flatMap { this, project in
                return this.projectLikeUseCase.like(projectId: project.id)
            }
            .withLatestFrom(searchResult) { like, projects -> [SideProjectListElement] in

                var newProject = projects

                if let index = newProject.firstIndex(where: { $0.id == like.project
                }) {
                    newProject[index].favorite = like.favorite
                    newProject[index].myFavorite = like.myFavorite
                }
                
                return newProject
            }
            .bind(to: searchResult)
            .disposed(by: disposeBag)
        
        input.participantsButtonTap
            .map { .participants($0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        return Output(
            searchHistoryList: searchHistoryList,
            searchIsEmpty: searchIsEmpty,
            searchResult: searchResult
        )
    }
}

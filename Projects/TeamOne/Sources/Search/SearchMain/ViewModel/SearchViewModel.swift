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
    case search(String)
}

final class SearchViewModel: ViewModel {
    
//    private let recentSearchHistoryUseCase = DIContainer.shared.resolve(RecentSearchHistoryUseCase.self)
    
    private let getRecentHistoryUseCase = DIContainer.shared.resolve(GetRecentHistoryUseCase.self)
    private let addRecentHistoryUseCase = DIContainer.shared.resolve(AddRecentHistoryUseCase.self)
    private let removeRecentHistoryUseCase = DIContainer.shared.resolve(RemoveRecentHistoryUseCase.self)
    
    private let projectUseCase = DIContainer.shared.resolve(ProjectListUseCaseProtocol.self)
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchHistoryInput: Observable<String>
        let tapSearch: Observable<Void>
        let tapDeleteHistory: Observable<String>
        let tapClearAllHistory: Observable<Void>
        let tapBack: Observable<Void>
        let tapKeyword: Observable<String>
    }
    
    struct Output {
        let searchHistoryList: PublishRelay<[String]>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<SearchNavigation>()
    
    func transform(input: Input) -> Output {
        
        let searchHistoryList = PublishRelay<[String]>()
        
        input.viewWillAppear
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                let historyList = this.getRecentHistoryUseCase.getRecentSearchHistory()
                searchHistoryList.accept(historyList)
            })
            .disposed(by: disposeBag)
        
        // MARK: 검색 이벤트
        input.tapSearch
            .withLatestFrom(input.searchHistoryInput)
            .withUnretained(self)
            .subscribe(onNext: { this, text in
                this.addRecentHistoryUseCase.addSearchHistory(text)
            })
            .disposed(by: disposeBag)
        
        // MARK: 최근 검색 삭제
        input.tapDeleteHistory
            .withUnretained(self)
            .subscribe(onNext: { this, keyword in
                this.removeRecentHistoryUseCase.deleteHistory(keyword)
            })
            .disposed(by: disposeBag)
        
        // MARK: 최근 검색 전부 삭제
        input.tapClearAllHistory
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                this.removeRecentHistoryUseCase.clearAllHistory()
            })
            .disposed(by: disposeBag)
        
        // MARK: 삭제 및 검색 이벤트 이후 검색 목록 리프레시
        Observable.merge([input.tapDeleteHistory.map { _ in },
                          input.tapClearAllHistory
        ])
        .withUnretained(self)
        .subscribe(onNext: { this, _ in
            let historyList = this.getRecentHistoryUseCase.getRecentSearchHistory()
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
        .bind { this, keyword in
//            projectUseCase.list()
//            this.navigation.onNext(.search(keyword))
        }
        .disposed(by: disposeBag)
        
        return Output(
            searchHistoryList: searchHistoryList
        )
    }
}

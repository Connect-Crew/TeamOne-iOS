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
    
    private let recentSearchHistoryUseCase = DIContainer.shared.resolve(RecentSearchHistoryUseCase.self)
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let searchHistoryInput: Observable<String>
        let tapSearch: Observable<Void>
        let tapDeleteHistory: Observable<String>
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
                let historyList = this.recentSearchHistoryUseCase.getRecentSearchHistory()
                searchHistoryList.accept(historyList)
            })
            .disposed(by: disposeBag)
        
        // MARK: 검색 이벤트
        input.tapSearch
            .withLatestFrom(input.searchHistoryInput)
            .withUnretained(self)
            .subscribe(onNext: { this, text in
                this.recentSearchHistoryUseCase.saveSearchHistory(text)
            })
            .disposed(by: disposeBag)
        
        // MARK: 최근 검색 삭제
        input.tapDeleteHistory
            .withUnretained(self)
            .subscribe(onNext: { this, keyword in
                this.recentSearchHistoryUseCase.deleteHistory(keyword)
            })
            .disposed(by: disposeBag)
        
        input.tapDeleteHistory
            .withUnretained(self)
            .subscribe(onNext: { this, _ in
                let historyList = this.recentSearchHistoryUseCase.getRecentSearchHistory()
                searchHistoryList.accept(historyList)
            })
            .disposed(by: disposeBag)
        
        return Output(
            searchHistoryList: searchHistoryList
        )
    }
}

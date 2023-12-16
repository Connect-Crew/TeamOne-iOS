//
//  SearchDetailViewModel.swift
//  TeamOne
//
//  Created by Junyoung on 12/9/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Domain
import Foundation
import RxSwift
import RxCocoa
import Core

enum SearchDetailNavigation {
    case finish
}

final class SearchDetailViewModel: ViewModel {
 
    public let searchKeyword = BehaviorSubject<[SideProjectListElement]>(value: [])
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let tapBack: Observable<Void>
    }
    
    struct Output {
        let searchResult: PublishRelay<[SideProjectListElement]>
    }
    
    var disposeBag: DisposeBag = .init()
    let navigation = PublishSubject<SearchDetailNavigation>()
    
    func transform(input: Input) -> Output {
        let searchResult = PublishRelay<[SideProjectListElement]>()
        
        Observable.combineLatest(self.searchKeyword, input.viewWillAppear)
            .map { result, _ -> [SideProjectListElement] in
                return result
            }
            .bind(to: searchResult)
            .disposed(by: disposeBag)
        
        input.tapBack
            .withUnretained(self)
            .bind { this, _ in
                this.navigation.onNext(.finish)
            }
            .disposed(by: disposeBag)
        
        return Output(
            searchResult: searchResult
        )
    }
}

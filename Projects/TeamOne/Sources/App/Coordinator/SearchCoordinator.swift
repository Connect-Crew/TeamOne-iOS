//
//  SearchCoordinator.swift
//  TeamOne
//
//  Created by Junyoung on 12/5/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Inject

import Core

enum SearchCoordinatorResult {
    case finish
}

final class SearchCoordinator: BaseCoordinator<SearchCoordinatorResult> {
    
    let finish = PublishSubject<SearchCoordinatorResult>()
    
    override func start() -> Observable<SearchCoordinatorResult> {
        pushToSearch()
        return finish
    }
    
    func pushToSearch() {
        let viewModel = SearchViewModel()
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    // 뒤로가기 버튼
                    self?.finish.onNext(.finish)
                case .search(let keyword):
                    self?.pushToKeyword(keyword)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(SearchViewController(viewModel: viewModel))
        
        pushTabbar(viewController, animated: true)
    }
    
    func pushToKeyword(_ key: String) {
        
    }
}

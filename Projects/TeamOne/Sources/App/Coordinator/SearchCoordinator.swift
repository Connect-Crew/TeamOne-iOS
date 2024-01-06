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
import Domain

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
                case .toProject(let data):
                    self?.toProject(data)
                case .participants(let data):
                    self?.toParticipants(data)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(SearchViewController(viewModel: viewModel))
        
        pushTabbar(viewController, animated: true)
    }
    
    func toProject(_ project: Project) {
        let projectDetail = ProjectDetailCoordinator(navigationController, project: project)
        
        coordinate(to: projectDetail)
            .subscribe(onNext: { _ in
                self.popTabbar(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func toParticipants(_ participants: SideProjectListElement?) {
        let viewController = Inject.ViewControllerHost(RecruitmentStatusDetailViewController(element: participants))

        viewController.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case let .detail(element: participants):
                    break
                }
            })
            .disposed(by: disposeBag)

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }
}

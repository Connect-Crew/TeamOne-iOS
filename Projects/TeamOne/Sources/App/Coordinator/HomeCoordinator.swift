//
//  HomeCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject
import Domain

enum HomeCoordinatorResult {
    case finish
}

final class HomeCoordinator: BaseCoordinator<HomeCoordinatorResult> {

    let finish = PublishSubject<HomeCoordinatorResult>()

    override func start() -> Observable<HomeCoordinatorResult> {
        showHome()
        return finish
    }

    func showHome() {
        let viewModel = DIContainer.shared.resolve(HomeViewModel.self)

        viewModel.navigation
            .subscribe(onNext: {  [weak self] in
                switch $0 {
                case .write:
                    break
                case .participants(let element):
                    self?.showparticipatnsDetail(element)
                }
            })
            .disposed(by: disposeBag)

       let viewController = Inject.ViewControllerHost(HomeViewController(viewModel: viewModel))
        push(viewController, animated: true, isRoot: true)
    }

    func showparticipatnsDetail(_ element: SideProjectListElement?) {
        let viewController = Inject.ViewControllerHost(RecruitmentStatusDetailViewController(element: element))

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }
}

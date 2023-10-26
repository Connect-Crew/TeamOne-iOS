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
            .subscribe(onNext: { _ in

            })
            .disposed(by: disposeBag)

    //   let viewController = Inject.ViewControllerHost(HomeViewController(viewModel: viewModel))
      //  let viewController = Inject.ViewControllerHost(TestViewController())
     //   push(viewController, animated: true, isRoot: true)
    }
}

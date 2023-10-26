//
//  LoginCoordinator.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject

enum LoginCoordinatorResult {
    case finish
}

final class LoginCoordinator: BaseCoordinator<LoginCoordinatorResult> {

    let finish = PublishSubject<LoginCoordinatorResult>()

    override func start() -> Observable<LoginCoordinatorResult> {
        showLogin()
        return finish
    }

    func showLogin() {
        let viewModel = DIContainer.shared.resolve(LoginViewModel.self)

        viewModel.navigation
            .subscribe(onNext: { _ in

            })
            .disposed(by: disposeBag)

       let viewController = Inject.ViewControllerHost(LoginViewController(viewModel: viewModel))
        
       push(viewController, animated: true, isRoot: true)
    }
}

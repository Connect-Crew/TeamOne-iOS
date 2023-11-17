//
//  LoginCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject
import Domain

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
        let viewModel = DIContainer.shared.resolve(LoginMainViewModel.self)
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case .getToken(let auth):
                    self?.showTerms(auth: auth)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(LoginMainViewController(viewModel: viewModel))
        
        push(viewController, animated: true, isRoot: true)
    }

    func showTerms(auth: OAuthSignUpProps) {
        let viewModel = DIContainer.shared.resolve(TosViewModel.self)

        viewModel.auth = auth

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.pop(animated: true)
                case .close:
                    self?.showLogin()
                case .finish(let auth):
                    self?.showSetNickName(auth: auth)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(TosViewController(viewModel: viewModel))

        push(viewController, animated: true)
    }

    func showSetNickName(auth: OAuthSignUpProps) {
        let viewModel = DIContainer.shared.resolve(SetNickNameViewModel.self)

        viewModel.auth = auth

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .close: self?.showLogin()
                case .back: self?.pop(animated: true)
                case .finish: self?.showSignUpResult()
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(SetNickNameViewController(viewModel: viewModel))

        push(viewController, animated: true)
    }

    func showSignUpResult() {
        let viewModel = DIContainer.shared.resolve(SignUpResultViewModel.self)

        viewModel.navigation
            .subscribe(onNext:{ [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(SignUpResultViewController(viewModel: viewModel))

        push(viewController, animated: true)
    }
}

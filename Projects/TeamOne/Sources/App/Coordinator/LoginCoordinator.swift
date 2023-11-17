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
        showSetNickName(token: "adsf", social: .apple)
//        showLogin()
//        showTerms(token: "Asdf", social: .apple)
        return finish
    }
    
    func showLogin() {
        let viewModel = DIContainer.shared.resolve(LoginMainViewModel.self)
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .getToken(let token, let social):
                    self?.showTerms(token: token, social: social)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(LoginMainViewController(viewModel: viewModel))
        
        push(viewController, animated: true, isRoot: true)
    }

    func showTerms(token: String, social: Social) {
        let viewModel = DIContainer.shared.resolve(TosViewModel.self)

        viewModel.token = token
        viewModel.social = social

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.pop(animated: true)
                case .close:
                    self?.pop(animated: true)
                case .finish(let token, let social):
                    self?.showSetNickName(token: token, social: social)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(TosViewController(viewModel: viewModel))

        push(viewController, animated: true)
    }

    func showSetNickName(token: String, social: Social) {
        let viewModel = DIContainer.shared.resolve(SetNickNameViewModel.self)

        let viewController = Inject.ViewControllerHost(SetNickNameViewController(viewModel: viewModel))

        push(viewController, animated: true)
    }
}

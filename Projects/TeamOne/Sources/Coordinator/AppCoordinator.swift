//
//  AppCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import RxSwift
import Core
import Inject

final class AppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow?

    init(_ window: UIWindow?) {
        self.window = window
       
        super.init(UINavigationController())
    }

    private func setup(with window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .teamOne.backgroundDefault
    }

    override func start() -> Observable<Void> {
        setup(with: window)
        showSplash()

        return Observable.never()
    }

    private func showSplash() {
        let viewModel = DIContainer.shared.resolve(SplashViewModel.self)

        viewModel.navigation
            .do(onNext: { [weak self] _ in
                self?.pop(animated: false)
            })
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.showLogin()
                case .autoLogin:
                    self?.showTab()
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(SplashViewController(viewModel: viewModel))

        push(viewController, animated: false)
    }

    private func showLogin() {
        navigationController.setNavigationBarHidden(true, animated: true)
        let tab = LoginCoordinator(navigationController)
        coordinate(to: tab)
            .subscribe(onNext: {
                switch $0 {
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func showTab() {
        navigationController.setNavigationBarHidden(true, animated: true)
        let tab = TabCoordinator(navigationController)
        coordinate(to: tab)
            .subscribe(onNext: {
                switch $0 {
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

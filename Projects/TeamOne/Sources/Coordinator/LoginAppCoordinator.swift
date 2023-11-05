//
//  LoginAppCoordinator.swift
//  TeamOne
//
//  Created by 임재현 on 2023/10/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit
import RxSwift
import Core

final class LoginAppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow?
    
    let navi = UINavigationController()

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
        showLogin()
    
        return Observable.never()
    }
    private func showLogin() {
        navigationController.setNavigationBarHidden(false, animated: false)
        
        //navigationController.set
        let login = LoginCoordinator(navigationController)
        coordinate(to: login)
            .subscribe(onNext: {
                switch $0 {
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}


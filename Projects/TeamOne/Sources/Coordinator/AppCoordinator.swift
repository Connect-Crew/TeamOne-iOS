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
        showTab()

        return Observable.never()
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

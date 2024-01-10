//
//  NotificationCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 1/10/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject
import Domain

enum NotificationResult {
    case finish
}

final class NotificationCoordinator: BaseCoordinator<NotificationResult> {

    let finish = PublishSubject<NotificationResult>()

    override func start() -> Observable<NotificationResult> {
        showNotification()
        return finish
    }

    func showNotification() {
        let viewModel = NotificationViewModel()
        
        viewModel.navigation
            .subscribe(onNext: {  [weak self] in
                switch $0 {
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)

       let viewController = Inject.ViewControllerHost(NotificationViewController(viewModel: viewModel))
        
        push(viewController, animated: true, isRoot: true)
    }
}

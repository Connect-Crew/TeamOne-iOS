//
//  SettingCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 1/30/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Inject
import Core
import Domain

enum SettingCoordinatorResult {
    case finish
    case back
}

final class SettingCoordinator: BaseCoordinator<SettingCoordinatorResult> {
    
    let finish = PublishSubject<SettingCoordinatorResult>()
    
    override func start() -> Observable<SettingCoordinatorResult> {
        showSetting()
        return finish
    }
    
    func showSetting() {
        let viewModel = SettingViewModel(
            signOutUseCase: DIContainer.shared.resolve(SignOutUseCase.self)
        )
        
        viewModel.navigation
            .withUnretained(self)
            .subscribe(onNext: { this, navi in
                switch navi {
                case .back:
                    this.popTabbar(animated: true)
                    this.finish.onNext(.back)
                case .logout:
                    this.popTabbar(animated: true)
                    this.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = Inject.ViewControllerHost(SettingViewController(viewModel: viewModel))
        
        pushTabbar(viewController, animated: true)
    }
}

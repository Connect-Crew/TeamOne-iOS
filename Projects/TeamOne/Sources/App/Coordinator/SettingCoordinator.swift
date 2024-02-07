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
            .do(onNext: { [weak self] _ in
                self?.popTabbar(animated: true)
            })
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
                    this.finish.onNext(.back)
                case .logout:
                    this.finish.onNext(.finish)
                case .dropout:
                    this.showDropout()
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = Inject.ViewControllerHost(SettingViewController(viewModel: viewModel))
        
        pushTabbar(viewController, animated: true)
    }
    
    func showDropout() {
        let viewModel = DropoutViewModel()
        viewModel.navigation
            .withUnretained(self)
            .subscribe(onNext: { this, navi in
                switch navi {
                case .finish:
                    break
                case .back:
                    this.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = Inject.ViewControllerHost(DropoutViewController(viewModel: viewModel))
        pushTabbar(viewController, animated: true)
    }
}

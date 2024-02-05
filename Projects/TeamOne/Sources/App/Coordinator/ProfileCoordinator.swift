//
//  ProfileCoordinator.swift
//  TeamOne
//
//  Created by Junyoung on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Inject

import Core

enum ProfileCoordinatorResult {
    case finish
}

final class ProfileCoordinator: BaseCoordinator<ProfileCoordinatorResult> {
    
    let finish = PublishSubject<ProfileCoordinatorResult>()
    
    override func start() -> Observable<ProfileCoordinatorResult> {
        showProfile()
        return finish
            .do(onNext: { [weak self] _ in
                self?.popTabbar(animated: true)
            })
    }
    
    func showProfile() {
        let viewModel = ProfileMainViewModel()
        
        viewModel.navigation
            .withUnretained(self)
            .subscribe(onNext: { this, navi in
                switch navi {
                case .finish:
                    break
                case .setting:
                    this.showSetting()
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = Inject.ViewControllerHost(ProfileMainVC(viewModel: viewModel))
        
        push(viewController, animated: true, isRoot: true)
    }
    
    func showSetting() {
        let setting = SettingCoordinator(navigationController)
        
        coordinate(to: setting)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back: break
                case .finish:
                    self?.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)
    }
}

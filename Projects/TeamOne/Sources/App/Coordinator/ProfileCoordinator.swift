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
import Domain

enum ProfileCoordinatorResult {
    case finish
}

final class ProfileCoordinator: BaseCoordinator<ProfileCoordinatorResult> {
    
    let finish = PublishSubject<ProfileCoordinatorResult>()
    
    override func start() -> Observable<ProfileCoordinatorResult> {
        showProfile()
        return finish
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
                case .myProject:
                    this.showMyProject()
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
    
    func showMyProject() {
        let viewModel = MyProjectViewModel(
            getMyProjectsUseCase: DIContainer.shared.resolve(GetMyProjectUseCase.self)
        )
        
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
        
        let viewController = Inject.ViewControllerHost(MyProjectVC(viewModel: viewModel))
        
        pushTabbar(viewController, animated: true)
    }
}

//
//  ProjectCreateCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 12/1/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import Inject
import Domain
import RxSwift

enum ProjectCreateCoordinatorResult {
    case finish
}

final class ProjectCreateCoordinator: BaseCoordinator<ProjectCreateCoordinatorResult> {

    let finish = PublishSubject<ProjectCreateCoordinatorResult>()

    override func start() -> Observable<ProjectCreateCoordinatorResult> {
        showPorjectCreate()
        return finish
            .do(onNext: { [weak self] _ in
                self?.popTabbar(animated: true)
            })
    }

    func showPorjectCreate() {
        let viewModel = ProjectCreateMainViewModel()

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .close:
                    self?.finish.onNext(.finish)
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(ProjectCreateMainViewController(viewModel: viewModel))

        pushTabbar(viewController, animated: true)
    }
}

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
    case created
}

final class ProjectCreateCoordinator: BaseCoordinator<ProjectCreateCoordinatorResult> {

    let finish = PublishSubject<ProjectCreateCoordinatorResult>()
    let type: ProjectCreateType
    let projectId: Int?
    
    public init(
        type: ProjectCreateType = .create,
        projectId: Int? = nil,
        _ navigationController: UINavigationController
    ) {
        self.type = type
        self.projectId = projectId
        super.init(navigationController)
    }

    override func start() -> Observable<ProjectCreateCoordinatorResult> {
        showPorjectCreate()
        return finish
            .do(onNext: { [weak self] _ in
                self?.popTabbar(animated: true)
            })
    }

    func showPorjectCreate() {
        
        let viewModel = ProjectCreateMainViewModel(
            projectCreateUseCase: DIContainer.shared.resolve(ProjectCreateUseCase.self),
            projectInfoUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self),
            type: type, 
            projectId: projectId
        )

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .close:
                    self?.finish.onNext(.finish)
                case .finish:
                    self?.finish.onNext(.created)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(ProjectCreateMainViewController(viewModel: viewModel))

        pushTabbar(viewController, animated: true)
    }
}

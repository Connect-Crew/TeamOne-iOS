//
//  ProjectDetailCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject
import Domain

enum ProjectDetailCoordinatorResult {
    case finish
}

final class ProjectDetailCoordinator: BaseCoordinator<ProjectDetailCoordinatorResult> {

    let finish = PublishSubject<ProjectDetailCoordinatorResult>()
    
    let project: Project

    init(_ navigationController: UINavigationController, project: Project) {
        self.project = project
        super.init(navigationController)
    }

    override func start() -> Observable<ProjectDetailCoordinatorResult> {
        showDetail()
        return finish
    }

    func showDetail() {
        let viewModel = ProjectDetailMainViewModel(
            projectUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self)
        )

        viewModel.project = project

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)

        let introduceVM = ProjectDetailPageSubIntroduceViewModel(
            projectLikeUseCase: DIContainer.shared.resolve(ProjectLikeUseCaseProtocol.self),
            projectUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self)
        )

        introduceVM.project.onNext(project)

        let reload = PublishSubject<Void>()

        introduceVM.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .apply(let project):
                    self?.showApply(project: project, isReload: reload)
                case .manageProject(let project):
                    self?.showManage(project: project, needRefreshSubject: reload)
                }
            })
            .disposed(by: disposeBag)

        reload.bind(to: introduceVM.reload)
            .disposed(by: disposeBag)

        let introduceVC = ProjectDetailPageSubIntroduceViewController(
            viewModel: introduceVM
        )

        let mainViewController = Inject.ViewControllerHost(ProjectDetailMainViewController(
            viewModel: viewModel,
            introduceVC: introduceVC))

        pushTabbar(mainViewController, animated: true)
    }

    func showApply(project: Project, isReload: PublishSubject<Void>) {
        let viewModel = ApplyViewModel(
            applyUseCase: DIContainer.shared.resolve(ProjectApplyUseCaseProtocol.self),
            projectUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self))

        viewModel.project.onNext(project)

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .close:
                    self?.dismiss(animated: false)
                    isReload.onNext(())
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(ApplyViewController(viewModel: viewModel))

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }
    
    func showManage(project: Project, needRefreshSubject: PublishSubject<Void>) {
        let manage = ManageProjectCoordinator(navigationController, project: project, needRefreshSubject: needRefreshSubject)
        
        coordinate(to: manage)
            .subscribe(onNext: {
                switch $0 {
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}

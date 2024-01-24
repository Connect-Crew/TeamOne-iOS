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
    
    // 디테일의 depth에서 변경이 일어나서 하위 디테일에 변경사항을 알려야 할 경우 사용
    static let refresh = PublishSubject<Void>()
    
    let project: Project

    init(_ navigationController: UINavigationController, project: Project) {
        self.project = project
        super.init(navigationController)
    }

    override func start() -> Observable<ProjectDetailCoordinatorResult> {
        showDetail()
        
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.popTabbar(animated: true)
                }
            })
    }

    func showDetail() {
        
        let viewModel = ProjectDetailMainViewModel(
            projectReportUseCase: DIContainer.shared.resolve(ProjectReportUseCase.self),
            memberFacade: DIContainer.shared.resolve(MemberFacade.self),
            projectLikeUseCase: DIContainer.shared.resolve(ProjectLikeUseCaseProtocol.self),
            projectInfoUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self),
            project: project
        )
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.finish.onNext(.finish)
                case .pushRepresentProejct(let project):
                    self?.showRepresentProject(project: project)
                case .profile:
                    // TODO: - 프로필이 나오면 프로필로 이동
                    break
                case .apply(let project):
                    self?.showApply(project: project)
                case .modify(let projectId):
                    self?.showModify(projectId: projectId)
                case .manageApplicants(let project):
                    self?.showManageApplicant(project: project)
                }
            })
            .disposed(by: disposeBag)

        let mainViewController = Inject.ViewControllerHost(ProjectDetailMainViewController(
            viewModel: viewModel))

        pushTabbar(mainViewController, animated: true)
    }

    func showApply(project: Project) {
        let viewModel = ApplyViewModel(
            project: project,
            applyUseCase: DIContainer.shared.resolve(ProjectApplyUseCaseProtocol.self),
            projectUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self))

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .close:
                    Self.refresh.onNext(())
                    self?.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(ApplyViewController(viewModel: viewModel))

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }
    
    func showModify(projectId: Int) {
        let modify = ProjectCreateCoordinator(
            type: .modify,
            projectId: projectId,
            navigationController
        )
        
        coordinate(to: modify)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .created:
                    Self.refresh.onNext(())
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showManageApplicant(project: Project) {
        let manageApplicant = ManageApplicantCoordinator(project: project, navigationController)
        
        coordinate(to: manageApplicant)
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
    
    func showRepresentProject(project: Project) {
        let detail = ProjectDetailCoordinator(
            navigationController,
            project: project
        )
        
        coordinate(to: detail)
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}

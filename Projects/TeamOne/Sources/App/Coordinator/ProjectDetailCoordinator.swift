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
    // 변동사항(좋아요변경)등을 상위 코디네이터에 전달해야하는 경우 필요한 서브젝트
    let changedProject = PublishSubject<Project>()
    let refresh = PublishSubject<Void>()
    
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
                case .manageProject(let project):
                    self?.showManage(project: project)
                }
            })
            .disposed(by: disposeBag)
        
        refresh
            .bind(to: viewModel.refresh)
            .disposed(by: disposeBag)
        
        viewModel.changedProject
            .bind(to: changedProject)
            .disposed(by: disposeBag)

        let mainViewController = Inject.ViewControllerHost(ProjectDetailMainViewController(
            viewModel: viewModel))

        pushTabbar(mainViewController, animated: true)
    }

    func showApply(project: Project) {
        let viewModel = ApplyViewModel(
            applyUseCase: DIContainer.shared.resolve(ProjectApplyUseCaseProtocol.self),
            projectUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self))

        viewModel.project.onNext(project)

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .close:
                    self?.refresh.onNext(())
                    self?.dismiss(animated: false)
                }
            })
            .disposed(by: disposeBag)

        let viewController = Inject.ViewControllerHost(ApplyViewController(viewModel: viewModel))

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }
    
    func showManage(project: Project) {
        let manage = ProjectManageCoordinator(navigationController, project: project)
        
        coordinate(to: manage)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    break
                case .modify:
                    self?.showModify(projectId: self?.project.id)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showModify(projectId: Int?) {
        let modify = ProjectCreateCoordinator(
            type: .modify,
            projectId: projectId,
            navigationController
        )
        
        coordinate(to: modify)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .created:
                    self?.refresh.onNext(())
                case .finish:
                    break
                }
            })
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

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
    let projectChangedSubject = PublishSubject<Project>()
    
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
            projectUseCase: DIContainer.shared.resolve(ProjectInfoUseCase.self)
        )

        viewModel.project = project

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.finish.onNext(.finish)
                case .pushRepresentProejct(let project):
                    self?.showProjectDetail(project: project)
                case .profile:
                    // TODO: - 프로필이 나오면 프로필로 이동
                    break
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
        
        // 좋아요된 프로젝트를 상위 코디네이터로 전달하기 위한 부분
        introduceVM.project
            .compactMap { $0 }
            .bind(to: self.projectChangedSubject)
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
        let manage = ProjectManageCoordinator(navigationController, project: project, needRefreshSubject: needRefreshSubject)
        
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
                    // TODO: - 생성하기 끝난 후 detail화면 refresh 추가
                    break
                case .finish:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func showProjectDetail(project: Project) {
        let detail = ProjectDetailCoordinator(
            navigationController,
            project: project
        )
        
        coordinate(to: detail)
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
}

//
//  ManageApplicantsCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core
import Inject
import Domain
import RxSwift

enum ManageApplicantCoordinatorResult {
    case back
    case joinned
}

final class ManageApplicantCoordinator: BaseCoordinator<ManageApplicantCoordinatorResult> {

    let finish = PublishSubject<ManageApplicantCoordinatorResult>()
    let project: Project
    
    public init(
        project: Project,
        _ navigationController: UINavigationController
    ) {
        self.project = project
        super.init(navigationController)
    }

    override func start() -> Observable<ManageApplicantCoordinatorResult> {
        pushTabBarManageApplicant()
        return finish
            .do(onNext: { [weak self] _ in
                self?.popTabbar(animated: true)
            })
    }

    func pushTabBarManageApplicant() {
        
        let viewModel = ManageApplicantMainViewModel(
            projectId: project.id,
            getApplyStatusUseCase: DIContainer.shared.resolve(GetApplyStatusUseCase.self)
        )

        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.finish.onNext(.back)
                case .detail:
                    break
//                    self?.pushTabBarDetail(project: project, status: part)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = Inject.ViewControllerHost(ManageApplicantMainViewController(viewModel: viewModel))

        pushTabbar(viewController, animated: true)
    }
    
    func pushTabBarDetail(project: Project, status: RecruitStatus) {
        
        let viewModel = ManageApplicantDetailViewModel()
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.popTabbar(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewControler = Inject.ViewControllerHost(
            ManageApplicantDetailViewController(viewModel: viewModel))
        
        pushTabbar(viewControler, animated: true)
    }
}


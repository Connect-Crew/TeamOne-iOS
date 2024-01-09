//
//  ProjectManageCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 1/2/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject
import Domain

enum ManageProjectCoordinatorResult {
    case finish
    case modify
}

final class ManageProjectCoordinator: BaseCoordinator<ManageProjectCoordinatorResult> {

    let finish = PublishSubject<ManageProjectCoordinatorResult>()
    
    let project: Project
    let needRefreshSubject: PublishSubject<Void>
    
    init(_ navigationController: UINavigationController, project: Project, needRefreshSubject: PublishSubject<Void>) {
        self.project = project
        self.needRefreshSubject = needRefreshSubject
        super.init(navigationController)
    }

    override func start() -> Observable<ManageProjectCoordinatorResult> {
        showManage()
        return finish
            .do(onNext: { [weak self] _ in
                self?.dismiss(animated: false)
            })
    }

    func showManage() {
        
        let viewModel = ManageProjectMainViewModel(project: project)
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case .manageApplicants:
                    break
                case .modify:
                    self?.finish.onNext(.modify)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = Inject.ViewControllerHost(ManageProjectMainVC(viewModel: viewModel))
        
        viewController.modalPresentationStyle = .overFullScreen
        
        present(viewController, animated: false)
    }
}

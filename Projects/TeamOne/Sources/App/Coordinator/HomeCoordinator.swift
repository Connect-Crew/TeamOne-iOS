//
//  HomeCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core
import Inject
import Domain

enum HomeCoordinatorResult {
    case finish
}

final class HomeCoordinator: BaseCoordinator<HomeCoordinatorResult> {

    let finish = PublishSubject<HomeCoordinatorResult>()
    let refreshHome = PublishSubject<Void>()
    
    // 프로젝트가 변경되어 새로운 프로젝트의 전달이 필요한 경우
    static let commonChangedProject = PublishSubject<Project>()
    static let deletedProject = PublishRelay<Void>()

    override func start() -> Observable<HomeCoordinatorResult> {
        showHome()
        return finish
    }

    func showHome() {
        
        let viewModel = DIContainer.shared.resolve(HomeViewModel.self)
        
        refreshHome
            .subscribe(onNext: {
                viewModel.refresh.onNext(())
            })
            .disposed(by: disposeBag)

        viewModel.navigation
            .subscribe(onNext: {  [weak self] in
                switch $0 {
                case .write:
                    self?.showPorjectCreate()
                case .participants(let element):
                    self?.showparticipatnsDetail(element)
                case .detail(let project):
                    self?.showDetail(project)
                case .search:
                    self?.pushToSearch()
                }
            })
            .disposed(by: disposeBag)

       let viewController = Inject.ViewControllerHost(HomeViewController(viewModel: viewModel))
        
        push(viewController, animated: true, isRoot: true)
    }

    func showparticipatnsDetail(_ element: SideProjectListElement?) {
        let viewController = Inject.ViewControllerHost(RecruitmentStatusDetailViewController(element: element))
        
        let projectInfoUseCase = DIContainer.shared.resolve(ProjectInfoUseCase.self)

        viewController.navigation
            .withUnretained(self)
            .subscribe(onNext: { this, finish in
                
                switch finish {
                case let .detail(id):
                    projectInfoUseCase.project(projectId: id)
                        .asObservable()
                        .subscribe(onNext: { project in
                            this.showDetail(project)
                        })
                        .disposed(by: this.disposeBag)
                }
            })
            .disposed(by: disposeBag)

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }

    func showDetail(_ project: Project) {

        let projectDetail = ProjectDetailCoordinator(navigationController, project: project)

        coordinate(to: projectDetail)
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
    }
    
    func pushToSearch() {

        let searchCoordinator = SearchCoordinator(navigationController)

        coordinate(to: searchCoordinator)
            .subscribe(onNext: { [weak self] _ in
                self?.popTabbar(animated: true)
            })
            .disposed(by: disposeBag)
    }

    func showPorjectCreate() {

        let projectCreate = ProjectCreateCoordinator(navigationController)

        coordinate(to: projectCreate)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    break
                case .created:
                    self?.refreshHome.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
}

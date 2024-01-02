//
//  HomeCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import Core
import Inject
import Domain

enum HomeCoordinatorResult {
    case finish
}

final class HomeCoordinator: BaseCoordinator<HomeCoordinatorResult> {

    let finish = PublishSubject<HomeCoordinatorResult>()

    override func start() -> Observable<HomeCoordinatorResult> {
        showHome()
        return finish
    }

    func showHome() {
        
        let viewModel = DIContainer.shared.resolve(HomeViewModel.self)
        
        let refreshHome = PublishSubject<Void>()
        
        ///  홈 화면에 리프레시가 필요할경우 해당 서브젝트로 Void 전달
        refreshHome
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)

        viewModel.navigation
            .subscribe(onNext: {  [weak self] in
                switch $0 {
                case .write:
                    self?.showPorjectCreate(refresh: refreshHome)
                case .participants(let element):
                    self?.showparticipatnsDetail(element)
                case .detail(let project):
                    self?.showDetail(project)
                }
            })
            .disposed(by: disposeBag)

       let viewController = Inject.ViewControllerHost(HomeViewController(viewModel: viewModel))
        
        push(viewController, animated: true, isRoot: true)
    }

    func showparticipatnsDetail(_ element: SideProjectListElement?) {
        let viewController = Inject.ViewControllerHost(RecruitmentStatusDetailViewController(element: element))

        viewController.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case let .detail(element: element):
                    break
                }
            })
            .disposed(by: disposeBag)

        viewController.modalPresentationStyle = .overFullScreen
        present(viewController, animated: false)
    }

    func showDetail(_ project: Project) {
        print("DEBUG: showDetail!!!!!!!!")

        let projectDetail = ProjectDetailCoordinator(navigationController, project: project)

        coordinate(to: projectDetail)
            .subscribe(onNext: { [weak self] _ in
                self?.popTabbar(animated: true)
            })
            .disposed(by: disposeBag)
    }

    func showPorjectCreate(refresh: PublishSubject<Void>) {

        let projectCreate = ProjectCreateCoordinator(navigationController)

        coordinate(to: projectCreate)
            .subscribe(onNext: {
                switch $0 {
                case .finish:
                    break
                case .created:
                    refresh.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }
}

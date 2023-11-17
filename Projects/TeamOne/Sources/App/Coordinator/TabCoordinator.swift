//
//  TabCoordinator.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/19.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import Core
import RxSwift
import DSKit

enum TabCoordinatorResult {
    case finish
}

final class TabCoordinator: BaseCoordinator<TabCoordinatorResult> {

    private var tabBarController = UITabBarController()
    private let finish = PublishSubject<TabCoordinatorResult>()

    override func start() -> Observable<TabCoordinatorResult> {
        push(tabBarController, animated: true, isRoot: true)
        setup()

        return finish
    }

    private func setup() {
        var rootViewControllers: [UINavigationController] = []

        Tablist.allCases.forEach {
            let navigationController = navigationController($0)
            rootViewControllers.append(navigationController)

            switch $0 {
            case .home: showHome(navigationController)
            case .community: break
            case .recruitment: break
            case .myteam: break
            case .profile: break
            }
        }

        tabBarController.setViewControllers(rootViewControllers, animated: true)
    }

    private func navigationController(_ tabItem: Tablist) -> UINavigationController {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: tabItem.title,
            image: UIImage.tabBar.loadSelectedImage(for: tabItem),
            tag: tabItem.rawValue
        )

        tabBarItem.selectedImage = UIImage.tabBar.loadSelectedImage(for: tabItem)
        tabBarItem.image = UIImage.tabBar.loadImage(for: tabItem)

        navigationController.tabBarItem = tabBarItem
        navigationController.isNavigationBarHidden = true

        return navigationController
    }

    private func showHome(_ root: UINavigationController) {
        let child = HomeCoordinator(root)

        coordinate(to: child)
            .subscribe(onNext: { _ in

            })
            .disposed(by: disposeBag)
    }

}

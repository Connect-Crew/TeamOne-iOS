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

enum Tablist: Int, CaseIterable {
    case home
    case notification
    case profile
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .notification: return "알림"
        case .profile:  return "마이페이지"
        }
    }
    
    var unSelectedImage: UIImage? {
        switch self {
        case .home:
            return .image(dsimage: .homeLine)
        case .notification:
            return .image(dsimage: .notificationLine)
        case .profile:
            return .image(dsimage: .profileLine)
        }
    }
    
    var selectedImage: UIImage? {
        switch self {
        case .home:
            return .image(dsimage: .homeSolid)
        case .notification:
            return .image(dsimage: .notificationSolid)
        case .profile:
            return .image(dsimage: .profileSolid)
        }
    }
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
            case .notification: showNotification(navigationController)
            case .profile: showProfile(navigationController)
            }
        }

        tabBarController.setViewControllers(rootViewControllers, animated: true)
    }

    private func navigationController(_ tabItem: Tablist) -> UINavigationController {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: tabItem.title,
            image: tabItem.unSelectedImage,
            tag: tabItem.rawValue
        )

        tabBarItem.selectedImage = tabItem.selectedImage

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
    
    private func showNotification(_ root: UINavigationController) {
        let notification = NotificationCoordinator(root)
        
        coordinate(to: notification)
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func showProfile(_ root: UINavigationController) {
        
        let coordinator = ProfileCoordinator(root)
        
        coordinate(to: coordinator)
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }

}

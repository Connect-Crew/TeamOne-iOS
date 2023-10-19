//
//  BaseCoordinator.swift
//  CoreTests
//
//  Created by 강현준 on 2023/10/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift

open class BaseCoordinator<ResultType> {
    public typealias CoordinationResult = ResultType

    private let identifier = String(describing: ResultType.self)
    private var childCoordinators: [String: Any] = [:]

    public let navigationController: UINavigationController

    public let disposeBag = DisposeBag()

    public init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    open func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented!!")
    }

    // MARK: - Child Coordinator

    private func append<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func remove<T>(coordinator: BaseCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    public func coordinate<T>(to coordinator: BaseCoordinator<T>) -> Observable<T> {
        append(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.remove(coordinator: coordinator)
            })
    }

    // MARK: - Push ∙ Pop

    public func push(_ viewController: UIViewController, animated: Bool, isRoot: Bool = false) {
        if isRoot {
            navigationController.viewControllers = [viewController]
        } else {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }

    public func pushTabbar(_ viewController: UIViewController, animated: Bool) {
        navigationController.tabBarController?.navigationController?.pushViewController(
            viewController,
            animated: animated
        )
    }

    public func pop(animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            navigationController.viewControllers = []
        } else {
            navigationController.popViewController(animated: animated)
        }
    }

    public func popTabbar(animated: Bool) {
        navigationController.tabBarController?.navigationController?.popViewController(animated: animated)
    }

    // MARK: - Present ∙ Dismiss

    public func presentTabbar(_ viewController: UIViewController, animated: Bool) {
        navigationController.tabBarController?.present(viewController, animated: animated)
    }

    public func dismissTabbar(animated: Bool) {
        navigationController.tabBarController?.dismiss(animated: animated)
    }

    // MARK: - Navigation Bar Hidden

    func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        navigationController.tabBarController?.navigationController?.setNavigationBarHidden(
            hidden,
            animated: animated
        )
    }

}

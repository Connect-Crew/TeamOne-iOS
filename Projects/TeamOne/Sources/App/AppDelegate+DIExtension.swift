//
//  AppDelegate+DIExtension.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Core
import Domain

extension AppDelegate {
    var container: DIContainer {
        DIContainer.shared
    }

    func registerDependencies() {

        // MARK: - Repository

        // MARK: - UseCase
        
        // MARK: - ViewModel

        container.register(interface:LoginViewModel.self) { resolver in
            let viewModel = LoginViewModel()

            return viewModel
        }

    }
}

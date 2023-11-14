//
//  AppDelegate+DIExtension.swift
//  TeamOne
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Core
import Domain
import Data

extension AppDelegate {

    var container: DIContainer {
        DIContainer.shared
    }

    func registerDependencies() {

        // MARK: - DataSource

        container.register(interface: KeychainProtocol.self) { resolver in
            let dataSource = Keychain()

            return dataSource
        }

        container.register(interface: KeychainManagerProtocol.self) { resolver in

            guard let keychain = resolver.resolve(KeychainProtocol.self) else { fatalError() }

            var dataSource = KeychainManager(keychain: keychain)

            return dataSource
        }

        container.register(interface: LoginDataSourceProtocol.self) { resolver in
            let dataSource = LoginDataSource()

            return dataSource
        }

        // MARK: - Repository

        container.register(interface: LoginRepositoryProtocol.self) { resolver in

            guard let loginDataSource = resolver.resolve(LoginDataSourceProtocol.self) else {
                fatalError()
            }

            let repository = LoginRepository(loginDataSource: loginDataSource)

            return repository
        }

        // MARK: - UseCase
        
        // MARK: - ViewModel

        container.register(interface: SplashViewModel.self) { _ in
            let viewModel = SplashViewModel()

            return viewModel
        }

        container.register(interface: LoginMainViewModel.self) { _ in
            let viewModel = LoginMainViewModel()

            return viewModel
        }

        container.register(interface: HomeViewModel.self) { _ in
            let viewModel = HomeViewModel()

            return viewModel
        }

        container.register(interface: TosViewModel.self) { _ in
            let viewModel = TosViewModel()

            return viewModel
        }

    }
}

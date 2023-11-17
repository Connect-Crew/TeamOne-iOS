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

        container.register(interface: AuthDataSourceProtocol.self) { _ in
            let dataSouce = AuthDataSource()

            return dataSouce
        }

        // MARK: - Repository

        container.register(interface: AuthRepositoryProtocol.self) { res in

            guard let authDataSource = res.resolve(AuthDataSourceProtocol.self),
            let tokenRepository = res.resolve(TokenRepositoryProtocol.self) else {
                fatalError("auth")
            }

            let repository = AuthRepository(
                authDataSource: authDataSource
//                tokenRepository: tokenRepository
            )

            return repository
        }

        container.register(interface: TokenRepositoryProtocol.self) { res in

            guard let keychainManager = res.resolve(KeychainManagerProtocol.self) else {
                fatalError()
            }

            return TokenRepository(
                keychainManager: keychainManager
            )
        }

        // MARK: - UseCase

        container.register(interface: SignUpUseCaseProtocol.self) { res in
            guard let authRepository = res.resolve(AuthRepositoryProtocol.self),
                  let tokenRepository = res.resolve(TokenRepositoryProtocol.self) else {
                fatalError()
            }

            return SignUpUseCase(
                authRepository: authRepository,
                tokenRepository: tokenRepository
            )
        }

        container.register(interface: LoginUseCaseProtocol.self) { res in
            guard let authRepository = res.resolve(AuthRepositoryProtocol.self),
                  let tokenRepository = res.resolve(TokenRepositoryProtocol.self) else {
                fatalError()
            }

            return LoginUseCase(
                authRepository: authRepository,
                tokenRepository: tokenRepository
            )
        }

        container.register(interface: AutoLoginUseCaseProtocol.self) { res in
            guard let authRepository = res.resolve(AuthRepositoryProtocol.self) else {
                fatalError()
            }

            return AutoLoginUseCase(authRepository: authRepository)
        }
        
        // MARK: - ViewModel

        container.register(interface: SplashViewModel.self) { res in
            guard let autoLoginUseCase = res.resolve(AutoLoginUseCaseProtocol.self) else {
                fatalError()
            }

            let viewModel = SplashViewModel(autoLoginUseCase: autoLoginUseCase)

            return viewModel
        }

        container.register(interface: LoginMainViewModel.self) { res in

            guard let loginUseCase = res.resolve(LoginUseCaseProtocol.self) else {
                fatalError()
            }

            let viewModel = LoginMainViewModel(loginUseCase: loginUseCase)

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

        container.register(interface: SetNickNameViewModel.self) { res in

            guard let signUpUseCase = res.resolve(SignUpUseCaseProtocol.self) else {
                fatalError()
            }

            let viewModel = SetNickNameViewModel(signUpUseCase: signUpUseCase)

            return viewModel
        }

        container.register(interface: SignUpResultViewModel.self) { _ in

            let viewModel = SignUpResultViewModel()

            return viewModel
        }

    }
}

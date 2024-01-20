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

        container.register(interface: ProjectsDataSouceProtocol.self) { _ in
            let dataSource = ProjectsDataSource()

            return dataSource
        }

        container.register(interface: UserDataSourceProtocol.self) { _ in
            let dataSource = UserDataSource()

            return dataSource
        }

        // MARK: - Repository

        container.register(interface: AuthRepositoryProtocol.self) { res in

            guard let authDataSource = res.resolve(AuthDataSourceProtocol.self) else { fatalError() }

            let repository = AuthRepository(
                authDataSource: authDataSource
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

        container.register(interface: ProjectRepositoryProtocol.self) { res in
            guard let projectDataSource = res.resolve(ProjectsDataSouceProtocol.self) else { fatalError() }

            return ProjectRepository(projectDataSource: projectDataSource)
        }

        container.register(interface: UserRepositoryProtocol.self) { res in
            guard let userDataSource = res.resolve(UserDataSourceProtocol.self) else { fatalError() }

            return UserRepository(userDataSource: userDataSource)
        }
        
        container.register(interface: RecentSearchHistoryRepository.self) { _ in
            DefaultRecentSearchHistoryRepository()
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

        container.register(interface: ProjectListUseCaseProtocol.self) { res in
            guard let projectRepository = res.resolve(ProjectRepositoryProtocol.self) else {
                fatalError()
            }

            return ProjectListUseCase(projectRepository: projectRepository)
        }

        container.register(interface: ProjectLikeUseCaseProtocol.self) { res in
            guard let projectRepository = res.resolve(ProjectRepositoryProtocol.self) else {
                fatalError()
            }

            return ProjectLikeUseCase(projectRepository: projectRepository)
        }

        container.register(interface: MyProfileUseCaseProtocol.self) { res in
            guard let userRepository = res.resolve(UserRepositoryProtocol.self) else {
                fatalError()
            }

            return MyProfileUseCase(userRepository: userRepository)
        }

        container.register(interface: ProjectInfoUseCase.self) { res in
            return BaseProjectInfoUseCase(
                projectRepository: res.resolve(ProjectRepositoryProtocol.self)!
            )
        }

        container.register(interface: ProjectApplyUseCaseProtocol.self) { res in
            return ProjectApplyUseCase(
                projectRepository: res.resolve(ProjectRepositoryProtocol.self)!
            )
        }

        container.register(interface: BaseProjectInformationUseCaseProtocol.self) { res in
            return BaseProjectInformationUseCase(
                projectRepository: res.resolve(ProjectRepositoryProtocol.self)!
            )
        }
        
        container.register(interface: RecentSearchHistoryUseCase.self) { _ in
            RecentSearchHistory()
        }
        
        container.register(interface: GetRecentHistoryUseCase.self) { _ in
            GetRecentHistory()
        }
        
        container.register(interface: AddRecentHistoryUseCase.self) { _ in
            AddRecentHistory()
        }
        
        container.register(interface: RemoveRecentHistoryUseCase.self) { _ in
            RemoveRecentHistory()
        }
        
        container.register(interface: RecentHistoryFacade.self) { _ in
            RecentHistory()
        }
        
        container.register(interface: ProjectCreateUseCase.self) { res in
            return DefaultProjectCreateUseCase(
                projectRepository: res.resolve(ProjectRepositoryProtocol.self)!
            )

        }
        
        container.register(interface: ProjectReportUseCase.self, implement: {res in
            return BaseProjectReportUseCase(
                projectRepository: res.resolve(ProjectRepositoryProtocol.self)!
            )
        })
        
        container.register(interface: GetProjectMemberUseCase.self, implement: { res in
            return GetProjectMember(projectRepository: res.resolve(ProjectRepositoryProtocol.self)!
            )
        })
        
        container.register(interface: MemberFacade.self, implement: { res in
            return BaseMemberFacade(
                getProjectMemberUseCase: res.resolve(GetProjectMemberUseCase.self)!
            )
        })
        
        container.register(interface: ProjectModifyUseCase.self, implement: { res in
            return DefaultProjectModifyUseCase(
                projectRepository: res.resolve(ProjectRepositoryProtocol.self)!
            )
        })

        // MARK: - ViewModel

        container.register(interface: SplashViewModel.self) { res in

            let viewModel = SplashViewModel(autoLoginUseCase: res.resolve(AutoLoginUseCaseProtocol.self)!)

            return viewModel
        }

        container.register(interface: LoginMainViewModel.self) { res in

            guard let loginUseCase = res.resolve(LoginUseCaseProtocol.self) else {
                fatalError()
            }

            let viewModel = LoginMainViewModel(loginUseCase: loginUseCase)

            return viewModel
        }

        container.register(interface: HomeViewModel.self) { res in

            let viewModel = HomeViewModel(
                projectListUseCase: res.resolve(ProjectListUseCaseProtocol.self)!,
                projectLikeUseCase: res.resolve(ProjectLikeUseCaseProtocol.self)!,
                myProfileUseCase: res.resolve(MyProfileUseCaseProtocol.self)!,
                projectUseCase: res.resolve(ProjectInfoUseCase.self)!
            )

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

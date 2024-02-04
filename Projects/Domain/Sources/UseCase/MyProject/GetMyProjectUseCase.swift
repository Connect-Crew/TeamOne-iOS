//
//  GetMyProjectUseCase.swift
//  Domain
//
//  Created by Junyoung on 2/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol GetMyProjectUseCase {
    func excute() -> Single<[MyProjects]>
}

public struct GetMyProject: GetMyProjectUseCase {
    
    private let getMyProjectsRepository: ProjectRepositoryProtocol
    
    public init(getMyProjectsRepository: ProjectRepositoryProtocol) {
        self.getMyProjectsRepository = getMyProjectsRepository
    }
    
    public func excute() -> Single<[MyProjects]> {
        return getMyProjectsRepository.getMyProjects()
    }
}

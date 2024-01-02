//
//  ProjectCreateUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectCreateUseCase {
    func create(props: ProjectCreateProps) -> Single<ProjectCreateResponse>
}

public struct DefaultProjectCreateUseCase: ProjectCreateUseCase {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func create(props: ProjectCreateProps) -> Single<ProjectCreateResponse> {
        
        return projectRepository.createProject(props: props)
    }
}


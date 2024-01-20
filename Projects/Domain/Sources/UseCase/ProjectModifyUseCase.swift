//
//  ProjectModifyUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/17/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectModifyUseCase {
    func modify(props: ProjectCreateProps, projectId: Int) -> Single<ProjectCreateResponse>
}

public struct DefaultProjectModifyUseCase: ProjectModifyUseCase {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func modify(props: ProjectCreateProps, projectId: Int) -> Single<ProjectCreateResponse> {
        
        return projectRepository.modify(props: props, projectId: projectId)
    }
}

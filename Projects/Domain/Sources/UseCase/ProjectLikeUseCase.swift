//
//  ProjectLikeUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/11/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectLikeUseCaseProtocol {
    func like(projectId: Int) -> Observable<Like>
}

public struct ProjectLikeUseCase: ProjectLikeUseCaseProtocol {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func like(projectId: Int) -> Observable<Like> {
        return projectRepository.like(projectId: projectId)
    }
}

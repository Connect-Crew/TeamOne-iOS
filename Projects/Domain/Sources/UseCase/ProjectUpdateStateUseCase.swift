//
//  ProjectUpdateStateUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/29/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectUpdateStateUseCase {
    func updateState(projectId: Int, state: ProjectState) -> Single<Void>
}

public struct ProjectUpdateState: ProjectUpdateStateUseCase {
    
    let projectRepository: ProjectRepositoryProtocol
    
    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func updateState(projectId: Int, state: ProjectState) -> Single<Void> {
        return projectRepository.updateState(projectId: projectId, state: state)
    }
}

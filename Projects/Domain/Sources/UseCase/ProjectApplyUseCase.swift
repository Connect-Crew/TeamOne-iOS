//
//  ProjectApplyUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/11/29.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectApplyUseCaseProtocol {
    func apply(projectId: Int, part: String, message: String) -> Single<Bool>
}

public struct ProjectApplyUseCase: ProjectApplyUseCaseProtocol {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func apply(projectId: Int, part: String, message: String) -> Single<Bool> {
        return projectRepository.apply(projectId: projectId, part: part, message: message)
    }
}

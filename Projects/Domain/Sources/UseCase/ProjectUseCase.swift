//
//  ProjectUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Core

public protocol ProjectUseCaseProtocol {
    func project(projectId: Int) -> Observable<Project>
    func isMyProject(project: Project) -> Bool
}

public struct ProjectUseCase: ProjectUseCaseProtocol {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func project(projectId: Int) -> Observable<Project> {
        return projectRepository.project(projectId: projectId)
    }

    public func isMyProject(project: Project) -> Bool {
        if let myId = UserDefaultKeyList.User.id {
            return project.leader.id == myId ? true : false
        } else {
            return false
        }
    }
}

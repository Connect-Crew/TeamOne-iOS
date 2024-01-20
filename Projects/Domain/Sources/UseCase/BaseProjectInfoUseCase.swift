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

public protocol ProjectInfoUseCase {
    /**
     프로젝트 정보
     - Authors: 강현준
     - parameters:
        - projectId: 프로젝트 ID
     - returns: Observable<Project>
     */
    func project(projectId: Int) -> Single<Project>
    
    func isMyProject(project: Project) -> Bool
}

public struct BaseProjectInfoUseCase: ProjectInfoUseCase {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func project(projectId: Int) -> Single<Project> {
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

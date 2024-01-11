//
//  GetProjectMemberUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol GetProjectMemberUseCase {
    func getProjectMember(projectId: Int) -> Single<[ProjectMember]>
}

public struct GetProjectMember: GetProjectMemberUseCase {
    
    private let projectRepository: ProjectRepositoryProtocol
    
    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func getProjectMember(projectId: Int) -> Single<[ProjectMember]> {
        return projectRepository.member(projectId: projectId)
    }
}

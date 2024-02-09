//
//  KickUserFromProjectUseCase.swift
//  Domain
//
//  Created by 강현준 on 2/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift

public protocol KickUserFromProjectUseCase {
    func kickUserFromProject(projectId: Int, userId: Int, reasons: [User_ExpelReason]) -> Single<ProjectMember>
}

public struct KickUserFromProject: KickUserFromProjectUseCase {
    
    let projectRepository: ProjectRepositoryProtocol
    
    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    /**
     프로젝트에서 유저를 내보냅니다.
     - Parameters:
        - projectId: 프로젝트의 ID
        - userId: 내보낼 유저의 ID
     - returns: 내보내진 유저 정보
     */
    public func kickUserFromProject(projectId: Int, userId: Int, reasons: [User_ExpelReason]) -> Single<ProjectMember> {
        
        return projectRepository.kickUserFromProject(projectId: projectId, userId: userId, reasons: reasons)
    }
}

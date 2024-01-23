//
//  GetApplyStatusUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol GetApplyStatusUseCase {
    func updateApplyStatus(project: Project) -> Single<[RecruitStatus]>
}

public struct GetApplyStatus: GetApplyStatusUseCase {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func updateApplyStatus(project: Project) -> Single<[RecruitStatus]> {
        
        return projectRepository.listAllApplicationsForProject(projectId: project.id)
            .map { applyStatusList in
                
                var current = project.recruitStatus
                
                for item in applyStatusList {
                    
                    if let index = current.firstIndex(where: { $0.partKey == item.partKey }) {
                        
                        current[index].current = item.current
                        current[index].max = item.max
                    }
                    
                }
                
                return current
            }
    }
}

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
    func getApplyStatus(projectId: Int) -> Single<[ApplyStatus]>
}

public struct GetApplyStatus: GetApplyStatusUseCase {
    
    private let projectRepository: ProjectRepositoryProtocol
    
    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func getApplyStatus(projectId: Int) -> Single<[ApplyStatus]> {
        
        return projectRepository.listAllApplicationsForProject(projectId: projectId)
            .map {
                return $0.sorted {
                    switch ($0.isQuotaFull, $1.isQuotaFull) {
                    case (true, false):
                        return false
                    case (false, true):
                        return true
                    default:
                        return $0.partKey < $1.partKey
                    }
                }
            }
    }
}

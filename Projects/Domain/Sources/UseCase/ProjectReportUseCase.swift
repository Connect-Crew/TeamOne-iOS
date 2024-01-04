//
//  ProjectReportUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectReportUseCase {
    /**
    프로젝트 신고
     - Authors: KKangHyeonJun
     - parameters:
        - projectId: 프로젝트Id
        - reason: 신고사유
     - returns: 신고 결과
     */
    func projectReport(projectId: Int, reason: String) -> Single<Bool>
}

public struct BaseProjectReportUseCase: ProjectReportUseCase {
    
    private let projectRepository: ProjectRepositoryProtocol
    
    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func projectReport(projectId: Int, reason: String) -> Single<Bool> {
        
        return projectRepository.report(projectId: projectId, reason: reason)
    }
}

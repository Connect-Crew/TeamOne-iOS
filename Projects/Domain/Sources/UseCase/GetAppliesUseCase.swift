//
//  GetAppliesUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol GetAppliesUseCase {
    /// 선택한 파트의 지원 정보를 가져옵니다
    func getApplies(projectId: Int, part: String) -> Single<[Applies]>
}

public struct GetApplies: GetAppliesUseCase {
    
    private let projectRepository: ProjectRepositoryProtocol
    
    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func getApplies(projectId: Int, part: String) -> Single<[Applies]> {
        
        return projectRepository.getApplies(projectId: projectId, part: part)
            .map { $0.sorted(by: { apply1, apply2 in
                switch (apply1.state, apply2.state) {
                case (.waiting, _): return true
                case (_, .waiting): return false
                default:
                    let date1 = apply1.leaderResponseAt.toDate() ?? .distantPast
                    let date2 = apply2.leaderResponseAt.toDate() ?? .distantPast
                    
                    return date1 < date2
                } } ) }
    }
}

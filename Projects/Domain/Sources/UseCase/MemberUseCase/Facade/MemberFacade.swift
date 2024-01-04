//
//  MemberFacade.swift
//  Domain
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol MemberFacade {
    func getProjectMembers(projectId: Int) -> Single<[ProjectMember]>
}

public struct BaseMemberFacade: MemberFacade {
    
    private let getProjectMemberUseCase: GetProjectMemberUseCase
    
    public init(getProjectMemberUseCase: GetProjectMemberUseCase) {
        self.getProjectMemberUseCase = getProjectMemberUseCase
    }
    
    public func getProjectMembers(projectId: Int) -> Single<[ProjectMember]> {
        return getProjectMemberUseCase.getProjectMemberUseCase(projectId: projectId)
    }
}

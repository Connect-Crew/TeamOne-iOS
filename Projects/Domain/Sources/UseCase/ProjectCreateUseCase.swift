//
//  ProjectCreateUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/1/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectCreateUseCase {
    func create(props: ProjectCreateProps) -> Single<ProjectCreateResponse>
}

public struct DefaultProjectCreateUseCase: ProjectCreateUseCase {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }

    public func create(props: ProjectCreateProps) -> Single<ProjectCreateResponse> {
        
        var mappedKeyProps = props
        
        let region = props.region == "" ? "NONE" : props.region
        let leaderParts = KM.shared.key(name: props.leaderParts)
        var recruits = [Recurit]()
        var categorys = [String]()
        
        props.recruits.forEach {
            var mappedRecruits = $0
            mappedRecruits.part = KM.shared.key(name: $0.part)
            recruits.append(mappedRecruits)
        }
        
        for category in props.category {
            categorys.append(KM.shared.key(name: category))
        }
        
        mappedKeyProps.region = region
        mappedKeyProps.leaderParts = leaderParts
        mappedKeyProps.recruits = recruits
        mappedKeyProps.category = categorys
        
        return projectRepository.createProject(props: mappedKeyProps)
    }
}


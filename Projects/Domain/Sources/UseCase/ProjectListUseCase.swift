//
//  ProjectListUseCase.swift
//  Domain
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol ProjectListUseCaseProtocol {
    func list(lastId: Int?, size: Int, goal: String?, career: String?, region: String?, online: String?, part: String?, skills: String?, states: String?, category: String?, search: String?) -> Observable<[SideProjectListElement]>
}

public struct ProjectListUseCase: ProjectListUseCaseProtocol {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func list(lastId: Int? = nil, size: Int, goal: String? = nil, career: String? = nil, region: String? = nil, online: String? = nil, part: String? = nil, skills: String? = nil, states: String? = nil, category: String? = nil, search: String? = nil) -> Observable<[SideProjectListElement]>{
        return projectRepository.list(lastId: lastId, size: size, goal: goal, career: career, region: region, online: online, part: part, skills: skills, states: states, category: category, search: search)
    }
}
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
    func list(lastId: Int?, size: Int, goal: String?, career: String?, region: String?, online: String?, part: String?, skills: String?, states: String?, category: String?, search: String?) -> Single<[SideProjectListElement]>
    
    func projectList(request: ProjectFilterRequest) -> Single<[SideProjectListElement]>
}

public struct ProjectListUseCase: ProjectListUseCaseProtocol {

    let projectRepository: ProjectRepositoryProtocol

    public init(projectRepository: ProjectRepositoryProtocol) {
        self.projectRepository = projectRepository
    }
    
    public func list(lastId: Int? = nil, size: Int, goal: String? = nil, career: String? = nil, region: String? = nil, online: String? = nil, part: String? = nil, skills: String? = nil, states: String? = nil, category: String? = nil, search: String? = nil) -> Single<[SideProjectListElement]>{
        return projectRepository.list(lastId: lastId, size: size, goal: goal, career: career, region: region, online: online, part: part, skills: skills, states: states, category: category, search: search)
            .map { list in
                let sortedData = list.sorted { first, second in
                    guard let first = first.createdAt.toDate(),
                          let second = second.createdAt.toDate() else {
                        return true
                    }
                    
                    return first > second
                }
                
                return sortedData
            }
    }
    
    public func projectList(request: ProjectFilterRequest) -> Single<[SideProjectListElement]>{
        return projectRepository.list(lastId: request.lastId,
                                      size: request.size,
                                      goal: request.goal,
                                      career: request.career,
                                      region: request.region,
                                      online: request.online,
                                      part: request.part,
                                      skills: request.skills,
                                      states: request.states,
                                      category: request.category,
                                      search: request.search)
    }
}

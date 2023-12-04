//
//  ProjectRepository.swift
//  Data
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Domain
import TeamOneNetwork
import Core

public struct ProjectRepository: ProjectRepositoryProtocol {

    let projectDataSource: ProjectsDataSouceProtocol

    public init(projectDataSource: ProjectsDataSouceProtocol) {
        self.projectDataSource = projectDataSource
    }

    public func baseInformation() -> Observable<BaseProjectInfoParameters> {
        return projectDataSource.baseInformation()
            .map {
                $0.toDomain()
            }
    }

    public func list(lastId: Int?, size: Int, goal: String?, career: String?, region: String?, online: String?, part: String?, skills: String?, states: String?, category: String?, search: String?) -> Observable<[SideProjectListElement]> {
        let request = ProjectListRequestDTO(
            lastId: lastId, size: "\(size)", goal: goal,
            career: career,
            region: region, online: online, part: part,
            skills: skills, states: states, category: category,
            search: search
        )

        return projectDataSource.list(request)
            .map { $0.map { $0.toDomain() }}
    }

    public func like(projectId: Int) -> Observable<Like> {
        let request = ProjectFavoriteRequestDTO(projectId: projectId)

        return projectDataSource.like(request)
            .map { $0.toDomain() }
    }

    public func project(projectId: Int) -> Observable<Project> {
        return projectDataSource.project(projectId)
            .map { $0.toDomain() }
    }

    public func apply(projectId: Int, part: String, message: String) -> Observable<Bool> {

        let request = ProjectApplyRequestDTO(
            projectId: projectId,
            part: part,
            message: message
        )

        return projectDataSource.apply(request)
            .map { $0.toDomain() }
            .catch({ error in
                guard let error = error as? APIError else
                {
                    return Observable.error(APIError.unknown)
                }

                switch error {
                case .network(let statusCode):
                    if statusCode == 400 {
                        return Observable.error(ApplyError.recruitComplete)
                    } else {
                        return Observable.error(ApplyError.recruitOthers)
                    }

                default: return Observable.error(ApplyError.recruitOthers)
                }
            })

    }
}

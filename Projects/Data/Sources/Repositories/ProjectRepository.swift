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
    }
    
    public func createProject(props: ProjectCreateProps) -> Single<ProjectCreateResponse> {
        
        let compactImages = props.banner.map { $0.jpegData(compressionQuality:  0.5)}
        
        let request = ProjectCreateRequestDTO(
            banner: compactImages,
            title: props.title,
            region: props.region,
            online: props.online,
            state: props.state,
            careerMin: props.careerMin,
            careerMax: props.careerMax,
            leaderParts: props.leaderParts,
            category: props.category,
            goal: props.goal,
            introduction: props.introducion,
            recruits: props.recruits.map {
                ProjectRecruitDTO(part: $0.part, comment: $0.comment, max: $0.max)
            },
            skills: props.skills
        )
        
        return projectDataSource.create(request)
            .map { $0.toDomain() }
    }
}

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
        
        
        let request = propsToRequestDTO(props: props)
        
        return projectDataSource.create(request)
            .map { $0.toDomain() }
    }
    
    func propsToRequestDTO(props: ProjectCreateProps) -> ProjectCreateRequestDTO {
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
        mappedKeyProps.region = KM.shared.key(name: props.region)
        
        let compactImagesData = props.banner.map { $0.jpegData(compressionQuality:  0.5)}
        
        return ProjectCreateRequestDTO(
            banner: compactImagesData, 
            title: mappedKeyProps.title,
            region: mappedKeyProps.region,
            online: mappedKeyProps.online.toBool(),
            state: mappedKeyProps.state.toMultiPartValue(), 
            careerMin: mappedKeyProps.careerMin.toMultiPartValue(),
            careerMax: mappedKeyProps.careerMax.toMultiPartValue(),
            leaderParts: mappedKeyProps.leaderParts,
            category: mappedKeyProps.category,
            goal: mappedKeyProps.goal.toMultiPartValue(),
            introduction: mappedKeyProps.introducion,
            recruits: mappedKeyProps.recruits.map {
                ProjectRecruitDTO(part: $0.part, comment: $0.comment, max: $0.max)
            },
            skills: mappedKeyProps.skills)
    }
}

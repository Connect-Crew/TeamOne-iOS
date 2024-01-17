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

    public func apply(projectId: Int, part: String, message: String) -> Single<Bool> {

        let request = ProjectApplyRequestDTO(
            projectId: projectId,
            part: part,
            message: message
        )

        return projectDataSource.apply(request)
            .map { $0.toDomain() }
    }
    
    public func createProject(props: ProjectCreateProps) -> Single<ProjectCreateResponse> {
        
        print("DEBUG: ProjectRepository 호출")
        
        let request = propsToRequestDTO(props: props)
        
        return projectDataSource.create(request)
            .map { $0.toDomain() }
    }
    
    public func report(projectId: Int, reason: String) -> Single<Bool> {
        
        let request = ProjectReportRequestDTO(
            projectId: projectId,
            reason: reason
        )
        
        return projectDataSource.report(request: request)
            .map { $0.toDomain() }
    }
    
    public func member(projectId: Int) -> Single<[ProjectMember]> {
        return projectDataSource.members(projectId: projectId)
            .map { $0.map { $0.toDomain()} }
    }
    
    public func modify(props: ProjectCreateProps, projectId: Int) -> Single<ProjectCreateResponse> {
        
        let request = propsToModifyRequestDTO(props: props)
        
        return projectDataSource.modify(request, projectId: projectId)
            .map { $0.toDomain() }
    }
}

extension ProjectRepository {
    
    func propsToRequestDTO(props: ProjectCreateProps) -> ProjectCreateRequestDTO {
        
        let region = props.region == nil ? "NONE" : KM.shared.key(name: props.region ?? "")
        var recruits = [Recruit]()
        var categories = [String]()
        
        props.recruits.forEach {
            var mappedRecruits = $0
            mappedRecruits.part = KM.shared.key(name: $0.part)
            recruits.append(mappedRecruits)
        }
        
        for category in props.category {
            categories.append(KM.shared.key(name: category))
        }
        
        var imageUploadRequestDTO = props.banner.map {
            return ImageUploadRequestDTO(name: $0.name, image: $0.image)
        }
        
        return ProjectCreateRequestDTO(
            banner: imageUploadRequestDTO,
            title: props.title ?? "",
            region: region,
            online: props.isOnline?.toBool() ?? false,
            state: props.state?.toMultiPartValue() ?? "",
            careerMin: props.careerMin?.toMultiPartValue() ?? "",
            careerMax: props.careerMax?.toMultiPartValue() ?? "",
            leaderParts: props.leaderParts?.key ?? "",
            category: categories,
            goal: props.goal?.toMultiPartValue() ?? "",
            introduction: props.introducion ?? "",
            recruits: props.recruits.map {
                
                ProjectRecruitDTO(
                    part: KM.shared.key(name: $0.part),
                    comment: $0.comment,
                    max: $0.max
                )
                
            },
            skills: props.skills)
    }
    
    func propsToModifyRequestDTO(props: ProjectCreateProps) -> ProjectModifyRequestDTO {
        let region = props.region == nil ? "NONE" : KM.shared.key(name: props.region ?? "")
        var recruits = [Recruit]()
        var categories = [String]()
        
        props.recruits.forEach {
            var mappedRecruits = $0
            mappedRecruits.part = KM.shared.key(name: $0.part)
            recruits.append(mappedRecruits)
        }
        
        for category in props.category {
            categories.append(KM.shared.key(name: category))
        }
        
        var imageUploadRequestDTO = props.banner.map {
            
            return ImageUploadRequestDTO(name: $0.name, image: $0.image)
        }
        
        return ProjectModifyRequestDTO(
            banner: imageUploadRequestDTO,
            removeBanners: props.removeBanners,
            title: props.title ?? "",
            region: region,
            online: props.isOnline?.toBool() ?? false,
            state: props.state?.toMultiPartValue() ?? "",
            careerMin: props.careerMin?.toMultiPartValue() ?? "",
            careerMax: props.careerMax?.toMultiPartValue() ?? "",
            leaderParts: props.leaderParts?.key ?? "",
            category: categories,
            goal: props.goal?.toMultiPartValue() ?? "",
            introduction: props.introducion ?? "",
            recruits: props.recruits.map {
                
                ProjectRecruitDTO(
                    part: KM.shared.key(name: $0.part),
                    comment: $0.comment,
                    max: $0.max
                )
                
            },
            skills: props.skills)
    }
}

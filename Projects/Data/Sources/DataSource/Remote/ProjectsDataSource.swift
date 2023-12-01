//
//  ProjectsDataSource.swift
//  Data
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import TeamOneNetwork
import RxSwift
import Core
import Alamofire

public protocol ProjectsDataSouceProtocol {
    func list(_ request: ProjectListRequestDTO) -> Observable<[ProjectListResponseDTO]>

    func like(_ request: ProjectFavoriteRequestDTO) -> Observable<ProjectFavoriteResponseDTO>

    func project(_ projectId: Int) -> Observable<ProjectResponseDTO>

    func apply(_ request: ProjectApplyRequestDTO) -> Observable<ProjectApplyResponseDTO>
}

public struct ProjectsDataSource: ProjectsDataSouceProtocol {

    private let provider: ProviderProtocol

    public init() {
        self.provider = Provider.default
    }

    public func list(_ request: ProjectListRequestDTO) -> Observable<[ProjectListResponseDTO]> {

        return provider.request(ProjectsTarget.list(request: request))
    }

    public func like(_ request: ProjectFavoriteRequestDTO) -> Observable<ProjectFavoriteResponseDTO> {
        return provider.request(ProjectsTarget.like(request: request))
    }

    public func project(_ projectId: Int) -> Observable<ProjectResponseDTO> {
        return provider.request(ProjectsTarget.project(projectId: projectId))
            .catch { _ in
                return Observable.error(ProjectError.loadFail)
            }
    }

    public func apply(_ request: ProjectApplyRequestDTO) -> Observable<ProjectApplyResponseDTO> {
        return provider.request(ProjectsTarget.apply(request: request))
    }
}

extension NetworkConstant {
    static let projectBasedURLString: String = "http://teamone.kro.kr:9080"
}

enum ProjectsTarget {
    case list(request: ProjectListRequestDTO)
    case like(request: ProjectFavoriteRequestDTO)
    case project(projectId: Int)
    case apply(request: ProjectApplyRequestDTO)
}

extension ProjectsTarget: TargetType {

    var baseURL: String {
        return NetworkConstant.projectBasedURLString
    }

    var method: HTTPMethod {
        switch self {
        case .list, .project:
            return .get
        case .like, .apply:
            return .post
        }
    }

    var header: HTTPHeaders {
        switch self {
        case .list, .like, .project, .apply:
            return ["Authorization": "Bearer \(UserDefaultKeyList.Auth.appAccessToken ?? "")"]
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .list(request: request):
            return .query(request)
        case let .like(request: request):
            return .body(request)
        case .project:
            return .none
        case let .apply(request: request):
            return .body(request)
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .list, .project:
            return  URLEncoding.default
        case .like, .apply:
            return JSONEncoding.default
        }
    }

    var path: String {
        switch self {
        case .list: return "/project/list"
        case .like: return "/project/favorite"
        case .project(projectId: let id): return "/project/\(id)"
        case .apply: return "/project/apply"
        }
    }
}

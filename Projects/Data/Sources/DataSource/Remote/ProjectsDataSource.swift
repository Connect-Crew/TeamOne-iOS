//
//  ProjectsDataSource.swift
//  Data
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Network
import RxSwift
import Core
import Alamofire

public protocol ProjectsDataSouceProtocol {
    func list(_ request: ProjectListRequestDTO) -> Observable<[ProjectListResponseDTO]>

    func like(_ request: ProjectFavoriteRequestDTO) -> Observable<ProjectFavoriteResponseDTO>
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
}

extension NetworkConstant {
    static let projectBasedURLString: String = "http://teamone.kro.kr:9080"
}

enum ProjectsTarget {
    case list(request: ProjectListRequestDTO)
    case like(request: ProjectFavoriteRequestDTO)
}

extension ProjectsTarget: TargetType {

    var baseURL: String {
        return NetworkConstant.projectBasedURLString
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .like:
            return .post
        }
    }

    var header: Network.HTTPHeaders {
        switch self {
        case .list, .like:
            return ["Authorization": "Bearer \(UserDefaultKeyList.Auth.appAccessToken ?? "")"]
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .list(request: request):
            return .query(request)
        case let .like(request: request):
            return .body(request)
        }
    }

    var encoding: Network.ParameterEncoding {
        switch self {
        case .list:
            return  URLEncoding.default
        case .like:
            return JSONEncoding.default
        }
    }

    var path: String {
        switch self {
        case .list: return "/project/list"
        case .like: return "/project/favorite"
        }
    }
}

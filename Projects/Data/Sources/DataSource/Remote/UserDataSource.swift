//
//  UserDataSource.swift
//  Data
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import TeamOneNetwork
import RxSwift
import Core
import Alamofire

public protocol UserDataSourceProtocol {
    func myProfile() -> Observable<BaseUserResponseDTO>
    
    func approve(applyId: Int) -> Single<Void>
    
    func reject(applyId: Int) -> Single<Void>
}

public struct UserDataSource: UserDataSourceProtocol {

    private let provider: ProviderProtocol

    public init() {
        self.provider = Provider.default
    }

    public func myProfile() -> Observable<BaseUserResponseDTO> {
        return provider.request(UserTarget.myProfile)
    }
    
    public func approve(applyId: Int) -> Single<Void> {
        return provider.request(UserTarget.approve(applyId: applyId))
    }
    
    public func reject(applyId: Int) -> Single<Void> {
        return provider.request(UserTarget.approve(applyId: applyId))
    }
}

extension NetworkConstant {
    static let userBasedURLString: String = "http://teamone.kro.kr:9080"
}

enum UserTarget {
    case myProfile
    case approve(applyId: Int)
    case reject(applyId: Int)
}

extension UserTarget: TargetType {
    var baseURL: String {
        return NetworkConstant.userBasedURLString
    }

    var method: HTTPMethod {
        switch self {
        case .myProfile:
            return .get
        case .approve, .reject:
            return .post
        }
    }

    var header: HTTPHeaders {
        switch self {
        case .myProfile:
            return ["Authorization": "Bearer \(UserDefaultKeyList.Auth.appAccessToken ?? "")"]
        
        default:
            return []
        }
    }

    var path: String {
        switch self {
        case .myProfile:
            return "/user/myprofile"
        case .approve(let applyId): return "/project/apply/\(applyId)/accept"
        case .reject(let applyId): return "/project/apply/\(applyId)/reject"
        }
    }

    var parameters: RequestParams? {
        switch self {
        case .myProfile:
            return .none
        case .approve, .reject:
            return .body(["leaderMessage"])
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .myProfile:
            return URLEncoding.default
        case .approve, .reject:
            return JSONEncoding.default
        }
    }
}

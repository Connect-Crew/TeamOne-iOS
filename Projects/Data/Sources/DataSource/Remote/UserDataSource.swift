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
    
    func reject(applyId: Int, message: String) -> Single<Void>
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
        return provider.request(UserTarget.approve(applyId: applyId, leaderMessage: "Approved"))
    }
    
    public func reject(applyId: Int, message: String) -> Single<Void> {
        return provider.request(UserTarget.reject(applyId: applyId, leaderMessage: message))
    }
}

extension NetworkConstant {
    static let userBasedURLString: String = "http://teamone.kro.kr:9080"
}

enum UserTarget {
    case myProfile
    case approve(applyId: Int, leaderMessage: String?)
    case reject(applyId: Int, leaderMessage: String)
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
        case .approve:
            return []
        default:
            return []
        }
    }

    var path: String {
        switch self {
        case .myProfile:
            return "/user/myprofile"
        case .approve(let applyId, _ ):
            return "/project/apply/\(applyId)/accept"
        case .reject(let aaplyId, _):
            return "/project/apply/\(aaplyId)/reject"
        }
    }

    var parameters: RequestParams? {
        switch self {
        case .myProfile:
            return .none
        case .approve(_, let message):
            return .plainText(["message": message])
        case .reject(_, let message):
            return .plainText(["message": message])
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .myProfile:
            return URLEncoding.default
        case .approve, .reject:
            return PlainTextEncoding.default
        }
    }
}

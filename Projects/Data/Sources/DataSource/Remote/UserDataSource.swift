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
    func myProfile() -> Observable<MyProfileResponseDTO>
}

public struct UserDataSource: UserDataSourceProtocol {

    private let provider: ProviderProtocol

    public init() {
        self.provider = Provider.default
    }

    public func myProfile() -> Observable<MyProfileResponseDTO> {
        return provider.request(UserTarget.myProfile)
    }
}

extension NetworkConstant {
    static let userBasedURLString: String = "http://teamone.kro.kr:9080"
}

enum UserTarget {
    case myProfile
}

extension UserTarget: TargetType {
    var baseURL: String {
        return NetworkConstant.userBasedURLString
    }

    var method: HTTPMethod {
        switch self {
        case .myProfile:
            return .get
        }
    }

    var header: HTTPHeaders {
        switch self {
        case .myProfile:
            return ["Authorization": "Bearer \(UserDefaultKeyList.Auth.appAccessToken ?? "")"]
        }
    }

    var path: String {
        switch self {
        case .myProfile:
            return "/user/myprofile"
        }
    }

    var parameters: RequestParams? {
        switch self {
        case .myProfile:
            return .none
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .myProfile:
            return URLEncoding.default
        }
    }
}

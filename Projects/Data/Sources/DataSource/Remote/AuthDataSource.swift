//
//  Auth.swift
//  Network
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import TeamOneNetwork
import RxSwift
import Core

extension NetworkConstant {
    static let authBasedURLString: String = "http://teamone.kro.kr:9080"
}

public protocol AuthDataSourceProtocol {

    func signup(_ request: AuthRegisterRequestDTO) -> Single<AuthResponseResponseDTO>

    func login(_ request: AuthLoginRequestDTO) -> Single<AuthResponseResponseDTO>

    func reissuance() -> Single<AuthRefreshResponseDTO>
}

public struct AuthDataSource: AuthDataSourceProtocol {

    private let provider: ProviderProtocol

    public init() {
        self.provider = Provider.default
    }

    public func login(_ request: AuthLoginRequestDTO) -> Single<AuthResponseResponseDTO> {
        return provider.request(AuthTarget.login(request: request))
    }

    public func signup(_ request: AuthRegisterRequestDTO) -> Single<AuthResponseResponseDTO> {
        return provider.request(AuthTarget.register(requst: request))
    }

    public func reissuance() -> Single<AuthRefreshResponseDTO> {
        let request = AuthRefreshRequtstDTO(
            refreshToken: UserDefaultKeyList.Auth.appRefreshToken ?? ""
        )

        return provider.requestNoInterceptor(AuthTarget.reissuance(request:request))
    }
}

enum AuthTarget {
    case login(request: AuthLoginRequestDTO)
    case register(requst: AuthRegisterRequestDTO)
    case reissuance(request: AuthRefreshRequtstDTO)
}

extension AuthTarget: TargetType {

    var baseURL: String {
        return NetworkConstant.authBasedURLString
    }

    var method: HTTPMethod {
        switch self {
        case .register, .login, .reissuance:
            return .post
        }
    }

    var header: HTTPHeaders {
        switch self {
        case .register, .login:
            return ["Content-Type": "application/json"]
        case .reissuance(let request):
            return ["Authorization": "Bearer \(request.refreshToken)"]
        }

    }

    var parameters: RequestParams? {
        switch self {
        case let .register(request):
            return .body(request)
        case let .login(request):
            return .body(request)
        case .reissuance:
            return .none
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }

    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .register: return "/auth/register"
        case .reissuance: return "/auth/refresh"
        }
    }
}

//
//  AppDataSource.swift
//  Data
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import TeamOneNetwork
import RxSwift
import Core
import Alamofire

public protocol AppDataSourceProtocol {
    func wish(request: WishRequestDTO) -> Single<WishResponseDTO>
}

public struct AppDataSource: AppDataSourceProtocol {

    private let provider: ProviderProtocol

    public init() {
        self.provider = Provider.default
    }
    
    public func wish(request: WishRequestDTO) -> Single<WishResponseDTO> {
        return provider.request(AppTarget.wish(request: request))
    }
}

extension NetworkConstant {
    static let appBaseURLString: String = "http://teamone.kro.kr:9080"
}

enum AppTarget {
    case wish(request: WishRequestDTO)
}

extension AppTarget: TargetType {
    var baseURL: String {
        return NetworkConstant.appBaseURLString
    }

    var method: HTTPMethod {
        switch self {
        case .wish:
            return .post
        }
    }

    var header: HTTPHeaders {
        switch self {
        case .wish:
            return []
        }
    }

    var path: String {
        switch self {
        case .wish:
            return "/wish"
        }
    }

    var parameters: RequestParams? {
        switch self {
        case .wish(let request):
            return .body(request)
        }
    }

    var encoding: ParameterEncoding {
        switch self {
        case .wish:
            return JSONEncoding.default
        }
    }
}


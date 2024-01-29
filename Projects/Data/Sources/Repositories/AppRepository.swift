//
//  AppRepository.swift
//  Data
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Domain

public struct AppRepository: AppRepositoryProtocol {

    private let appDataSource: AppDataSourceProtocol

    public init(appDataSource: AppDataSourceProtocol) {
        self.appDataSource = appDataSource
    }

    public func wish(message: String) -> Single<String> {
        let request = WishRequestDTO(message: message)
        return appDataSource.wish(request: request)
            .map { $0.message }
    }
}

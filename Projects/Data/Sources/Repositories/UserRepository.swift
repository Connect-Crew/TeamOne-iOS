//
//  UserRepository.swift
//  Data
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift
import Domain
import Core

public struct UserRepository: UserRepositoryProtocol {

    private let userDataSource: UserDataSourceProtocol

    public init(userDataSource: UserDataSourceProtocol) {
        self.userDataSource = userDataSource
    }

    public func myProfile() -> Observable<Profile> {
        return self.userDataSource.myProfile()
            .map { $0.toDomain() }
            .catch({ _ in
                return Observable.error(UserError.loadFail)
            })
    }
}

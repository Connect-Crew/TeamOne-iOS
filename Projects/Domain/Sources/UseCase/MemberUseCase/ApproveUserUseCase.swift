//
//  ApproveUserUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/29/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift
import Foundation

public protocol ApproveUserUseCase {
    func approve(applyId: Int) -> Single<Void>
}

public struct ApproveUser: ApproveUserUseCase {
    
    private let userRepository: UserRepositoryProtocol
    
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func approve(applyId: Int) -> Single<Void> {
        return userRepository.approve(applyId: applyId)
    }
}

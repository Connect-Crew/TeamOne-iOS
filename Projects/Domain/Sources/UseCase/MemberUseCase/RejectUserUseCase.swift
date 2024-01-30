//
//  RejectUserUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/29/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol RejectUserUseCase {
    func reject(applyId: Int, rejectMessage: String) -> Single<Void>
}

public struct RejectUser: RejectUserUseCase {
    
    private let userRepository: UserRepositoryProtocol
    
    public init(userRepository: UserRepositoryProtocol) {
        self.userRepository = userRepository
    }
    
    public func reject(applyId: Int, rejectMessage: String) -> Single<Void> {
        return userRepository.reject(applyId: applyId, rejectMessage: rejectMessage)
    }
}

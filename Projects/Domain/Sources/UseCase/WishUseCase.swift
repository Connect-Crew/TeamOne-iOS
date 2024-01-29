//
//  WishUseCase.swift
//  Domain
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import RxSwift

public protocol WishUseCase {
    func wish(message: String) -> Single<String> 
}

public struct Wish: WishUseCase {
    
    private let appRepository: AppRepositoryProtocol
    
    public init(appRepository: AppRepositoryProtocol) {
        self.appRepository = appRepository
    }
    
    public func wish(message: String) -> Single<String> {
        return appRepository.wish(message: message)
    }
}

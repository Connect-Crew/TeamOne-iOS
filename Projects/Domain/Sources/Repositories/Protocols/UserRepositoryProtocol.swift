//
//  UserRepositoryProtocol.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol UserRepositoryProtocol {
    func myProfile() -> Observable<Profile>
    
    func approve(applyId: Int) -> Single<Void>
    
    func reject(applyId: Int, rejectMessage: String) -> Single<Void> 
}

//
//  LoginRepositoryProtocol.swift
//  Domain
//
//  Created by 강현준 on 2023/11/07.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol LoginRepositoryProtocol {
    func getkakaoOAuthToken() -> Single<Authorization>
}

//
//  TokenRepositoryProtocol.swift
//  Domain
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import RxSwift

public protocol TokenRepositoryProtocol {
    func save(_ auth: Authorization) -> Observable<Authorization>
    func load() -> Observable<Authorization>
    func deleteAuth() -> Observable<Void>
}

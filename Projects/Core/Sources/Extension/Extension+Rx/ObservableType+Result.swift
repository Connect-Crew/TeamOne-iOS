//
//  ObservableType+Result.swift
//  Core
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift

public extension ObservableType {
    public func asResult() -> Observable<Result<Element, Error>> {
        return self.map { .success($0) }
            .catch { .just(.failure($0)) }
    }
}

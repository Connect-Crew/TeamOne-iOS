//
//  ObservableType+Result.swift
//  Core
//
//  Created by 강현준 on 2023/11/16.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift

public extension ObservableType {
    
    /// 옵저버블 타입을 옵저버블 리절트 타입으로 변경합니다.
    func asResult() -> Observable<Result<Element, Error>> {
        return self.map { .success($0) }
            .catch { .just(.failure($0)) }
    }
}

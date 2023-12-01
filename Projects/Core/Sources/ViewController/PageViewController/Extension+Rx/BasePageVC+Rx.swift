//
//  BasePageVC+Rx.swift
//  Core
//
//  Created by 강현준 on 2023/11/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import RxSwift
import RxCocoa

public extension Reactive where Base: BasePageViewController {
    var goToPage: Binder<Int> {
        return Binder(self.base) { pageVC, index in
            base.goToPage(index)
        }
    }
}

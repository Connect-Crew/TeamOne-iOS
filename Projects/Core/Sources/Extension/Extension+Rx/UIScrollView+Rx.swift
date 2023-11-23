//
//  UIScrollView+Rx+Rx.swift
//  Core
//
//  Created by 강현준 on 2023/11/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: UIScrollView {
    var reachedBottom: Observable<Void> {
        return base.rx.contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else { return Observable.empty() }

                let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)

                return y > threshold ? Observable.just(()) : Observable.empty()
            }
    }
}

//
//  TOTgle+Rx.swift
//  DSKit
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: TOTogle {
    
    /// Reactive Rapper for `isOn` property
    public var isOn: ControlProperty<Bool> {
        let source: Observable<Bool> = self.base.rx_isOn.asObservable()
        let observer = AnyObserver<Bool> { [weak base] event in
            switch event {
            case .next(let value): base?.isOn = value
            default: break
            }
        }
        
        return ControlProperty(values: source, valueSink: observer)
    }
    
    /// Reactive wrapper for `isOn` property
    /// This is `ControlEvent` that emits the value of the `isOn` property when a tap event. Can't assign a value to change the `isOn`property's value through this value
    public var tap: Observable<Void> {
        let observer = base.tapSubject
        return observer.asObservable()
    }
}

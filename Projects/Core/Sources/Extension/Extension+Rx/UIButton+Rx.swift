//
//  UIButton+Rx.swift
//  Core
//
//  Created by 강현준 on 1/12/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    /// Reactive Rapper for `isSelected` property
    public var isSelected: ControlProperty<Bool> {
        return base.rx.controlProperty(editingEvents: .touchUpInside, getter: { button in
            return button.isSelected
        }, setter: { button, value in
            button.isSelected = value
        })
    }
    
}

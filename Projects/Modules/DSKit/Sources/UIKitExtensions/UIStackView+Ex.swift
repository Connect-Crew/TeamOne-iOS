//
//  UIStackView+Ex.swift
//  DSKitTests
//
//  Created by 강현준 on 2023/11/06.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UIStackView {
    func addArrangeSubViews(views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}

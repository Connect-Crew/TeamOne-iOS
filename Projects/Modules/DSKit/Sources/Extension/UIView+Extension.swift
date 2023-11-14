//
//  UIView+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/11.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public extension UIView {
    func setDivider(height: CGFloat, color: UIColor) {
        self.backgroundColor = color
        self.snp.makeConstraints {
            $0.height.equalTo(height)
        }
    }

    func setRound(radius: CGFloat) {
        self.layer.cornerRadius = radius
    }
}

//
//  UIButton+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UIButton {
    func setButton(text: String, typo: SansNeo) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .setFont(font: typo)
    }
}

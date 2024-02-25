//
//  UILabel+Extension.swift
//  DSKitTests
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UILabel {
    
    /**
     Label을 설정합니다
     - Parameters :
        - text: String
        - type: Font
        - color: TextColor
     */
    func setLabel(text: String?, typo: SansNeo, color: UIColor) {
        self.text = text
        self.font = .setFont(font: typo)
        self.textColor = color
    }
}

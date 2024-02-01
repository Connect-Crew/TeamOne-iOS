//
//  UIButton+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public extension UIButton {
    /**
     UIButton을 Text로 설정합니다.
     - Parameters:
        - text: Button's Title
        - typo: Font
        - color: TextColor
     */
    func setButton(text: String, typo: SansNeo, color: UIColor) {
        self.setTitle(text, for: .normal)
        self.titleLabel?.font = .setFont(font: typo)
        self.setTitleColor(color, for: .normal)
    }

    /**
     UIButton을 Image로 설정합니다.
     - Parameters:
        - image: DSKitImage
     */
    func setButton(image: DSKitImage) {
        guard let image = UIImage(named: image.toName, in: Bundle.module, compatibleWith: nil) else { return }
        self.setImage(image, for: .normal)
    }

    /**
     It's Sets the font of the UIButton
     */
    func setFont(typo: SansNeo) {
        self.titleLabel?.font = .setFont(font: typo)
    }
}

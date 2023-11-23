//
//  Button+IsEnabledImage.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/19.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class Button_IsEnabledImage: UIButton {

    let enabledImage: UIImage?
    let disabledImage: UIImage?
    let enabledTextColor: UIColor
    let disabledTextColor: UIColor

    public init(text: String, typo: SansNeo,
                enabledImage: DSKitImage, disabledImage: DSKitImage,
                enabledTextColor: UIColor, disabledTextColor: UIColor
    ) {
        self.enabledImage = .image(dsimage: enabledImage)
        self.disabledImage = .image(dsimage: disabledImage)
        self.enabledTextColor = enabledTextColor
        self.disabledTextColor = disabledTextColor

        super.init(frame: .zero)

        self.contentHorizontalAlignment = .center
        self.titleLabel?.font = .setFont(font: typo)
        self.setTitle(text, for: .normal)

        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isEnabled: Bool {
        didSet{
            if isEnabled {
                self.setImage(enabledImage, for: .normal)
                self.setTitleColor(enabledTextColor, for: .normal)
            } else {
                self.setImage(disabledImage, for: .normal)
                self.setTitleColor(disabledTextColor, for: .normal)
            }
        }
    }
}

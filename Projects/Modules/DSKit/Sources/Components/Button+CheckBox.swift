//
//  Button+CheckBox.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class Button_CheckBox: UIButton {

    public init(text: String, typo: SansNeo, textColor: UIColor) {

        super.init(frame: .zero)

        self.contentHorizontalAlignment = .left
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        self.setImage(.image(dsimage: .checkNONOE), for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.setButton(text: text, typo: typo, color: textColor)
    }

    public override var isSelected: Bool {
        didSet {
            if isSelected {
                self.setImage(.image(dsimage: .checkOK), for: .normal)
            } else {
                self.setImage(.image(dsimage: .checkNONOE), for: .normal)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

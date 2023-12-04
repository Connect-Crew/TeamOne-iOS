//
//  Button+CheckBox.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public enum CheckBoxType {
    case vColor
    case checkBox
}

public class Button_CheckBox: UIButton {

    public var checkedImage = UIImage.image(dsimage: .checkOK)
    public var noneCheckedImage = UIImage.image(dsimage: .checkNONOE)

    public var type: CheckBoxType = .vColor{
        didSet {
            changeType()
        }
    }

    func changeType() {
        switch type {
        case .vColor:
            self.checkedImage = UIImage.image(dsimage: .checkOK)
            self.noneCheckedImage = UIImage.image(dsimage: .checkNONOE)
        case .checkBox:
            self.checkedImage = UIImage.image(dsimage: .CheckBoxChecked)
            self.noneCheckedImage = UIImage.image(dsimage: .CheckBoxNotChecked)
        }
    }

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
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(noneCheckedImage, for: .normal)
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

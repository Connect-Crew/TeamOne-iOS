//
//  Button+IsEnabled.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class Button_IsEnabled: UIButton {

    public override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.backgroundColor = .teamOne.mainColor
                self.setTitleColor(.white, for: .normal)
            } else {
                self.backgroundColor = .teamOne.grayscaleTwo
                self.setTitleColor(.teamOne.grayscaleFive, for: .normal)
            }
        }
    }

}

//
//  Button+IsEnabled.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/14.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public class Button_IsEnabled: UIButton {

    public var enabledString: String? = nil {
        didSet {
            setEnabled()
        }
    }
    
    
    public var disabledString: String? = nil {
        didSet {
            setEnabled()
        }
    }

    public init(enabledString: String, disabledString: String) {
        self.enabledString = enabledString
        self.disabledString = disabledString
        super.init(frame: .zero)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var isEnabled: Bool {
        didSet {
            setEnabled()
        }
    }
    
    private func setEnabled() {
        if isEnabled {
            self.backgroundColor = .teamOne.mainColor
            self.setTitleColor(.white, for: .normal)
            self.setTitle(self.enabledString, for: .normal)
        } else {
            self.backgroundColor = .teamOne.grayscaleTwo
            self.setTitleColor(.teamOne.grayscaleFive, for: .normal)
            self.setTitle(self.disabledString, for: .normal)
        }
    }

}

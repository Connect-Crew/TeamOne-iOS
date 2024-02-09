//
//  Button+IsEnabled_Dropout.swift
//  DSKit
//
//  Created by 강창혁 on 2/9/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit

public class Button_IsEnabled_Dropout: UIButton {

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
            self.backgroundColor = .teamOne.point
            self.setTitleColor(.white, for: .normal)
            self.setTitle(self.enabledString, for: .normal)
            self.setFont(typo: .button1)
        } else {
            self.backgroundColor = .teamOne.grayscaleTwo
            self.setTitleColor(.teamOne.grayscaleFive, for: .normal)
            self.setTitle(self.disabledString, for: .normal)
            self.setFont(typo: .button2)
        }
    }

}

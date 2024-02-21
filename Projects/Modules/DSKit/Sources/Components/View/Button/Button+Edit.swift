//
//  Button+Edit.swift
//  DSKit
//
//  Created by 강현준 on 2/13/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit
import Core

public final class Button_Edit: RoundableButton {
    
    public let textInset: UIEdgeInsets
    
    public init(inset: UIEdgeInsets = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)) {
        self.textInset = inset
        
        super.init(frame: .zero)
        
        self.setButton(text: "수정하기", typo: .caption1, color: .teamOne.grayscaleSeven)
        self.backgroundColor = .teamOne.grayscaleTwo
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var intrinsicContentSize: CGSize {
        guard let titleSize = titleLabel?.intrinsicContentSize else {
            return CGSize(width: 0, height: 0)
        }
        
        let width = titleSize.width + textInset.left + textInset.right
        
        let height = titleSize.height + textInset.top + textInset.bottom
        
        return CGSize(width: width, height: height)
    }
}

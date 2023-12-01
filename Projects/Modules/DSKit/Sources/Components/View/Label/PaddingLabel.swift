//
//  PaddingLabel.swift
//  DSKit
//
//  Created by 강현준 on 2023/11/28.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public class PaddingLabel: UILabel {
    
    public var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + textInsets.left + textInsets.right,
                      height: size.height + textInsets.top + textInsets.bottom)
    }

    public override func sizeToFit() {
        super.sizeThatFits(intrinsicContentSize)
    }
}

//
//  PaddingLabel.swift
//  Core
//
//  Created by 강현준 on 1/29/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

/// 라벨에 여백을 적용한 커스텀 라벨입니다.
/// textInsets에 UIEdgeInsets를 설정합니다.
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

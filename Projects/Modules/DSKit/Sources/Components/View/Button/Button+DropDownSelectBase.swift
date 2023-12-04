//
//  Button+DropDownSelectBase.swift
//  DSKit
//
//  Created by 강현준 on 12/4/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SnapKit

public class Button_DropDownSelectBase: Button_IsSelected {

    var rightViewImage = UIImage.image(dsimage: .downTow)

    public override init() {
        super.init()

        self.setImage(rightViewImage, for: .normal)
        imageViewToRight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func imageViewToRight() {
        self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.titleLabel!.frame.size.width, bottom: 0, right: -self.titleLabel!.frame.size.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -self.imageView!.frame.size.width, bottom: 0, right: self.imageView!.frame.size.width)
    }
}

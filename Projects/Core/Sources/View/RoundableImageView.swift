//
//  RoundableImageView.swift
//  Core
//
//  Created by 강현준 on 2/13/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

open class RoundableImageView: UIImageView {
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
}

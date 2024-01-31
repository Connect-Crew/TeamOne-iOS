//
//  RoundableView.swift
//  Core
//
//  Created by 강현준 on 1/31/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

open class RoundableView: View {
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.frame.height / 2
    }
}

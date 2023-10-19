//
//  Color+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }

    static let teamOne = TeamOneColor()
}

public struct TeamOneColor {
    public let backgroundDefault = UIColor(r: 253, g: 253, b: 253, a: 1)
}

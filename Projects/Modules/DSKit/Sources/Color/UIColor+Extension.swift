//
//  Color+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import SwiftUI

public extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }

    static let teamOne = TeamOneColor()
    
    static let backgroundDefault = UIColor(r: 253, g: 253, b: 253, a: 1)
    static let mainColor = UIColor(r: 0, g: 174, b: 228, a: 1)
    static let mainlightColor = UIColor(r: 241, g: 252, b: 255, a: 1)
    static let background = UIColor(r: 249, g: 250, b: 252, a: 1)
    static let point = UIColor(r: 214, g: 37, b: 70, a: 1)
    static let pointTwo = UIColor(r: 247, g: 205, b: 213, a: 1)
    static let grayscaleEight = UIColor(r: 66, g: 66, b: 66, a: 1)
    static let grayscaleSeven = UIColor(r: 97, g: 97, b: 97, a: 1)
    static let grayscaleFive = UIColor(r: 158, g: 158, b: 158, a: 1)
    static let grayscaleTwo = UIColor(r: 238, g: 238, b: 238, a: 1)
    static let grayscaleOne = UIColor(r: 245, g: 245, b: 245, a: 1)
    static let bgColor = UIColor(r: 249, g: 250, b: 252, a: 1)
    static let transparent = UIColor(r: 0, g: 0, b: 0, a: 0.7)
    static let levelOneColor = UIColor(r: 255, g: 251, b: 214, a: 1)
    static let levelTwoColor = UIColor(r: 255, g: 251, b: 138, a: 1)
    static let levelThreeColor = UIColor(r: 254, g: 234, b: 53, a: 1)
    static let levelFourColor = UIColor(r: 255, g: 206, b: 16, a: 1)
    static let levelFiveColor = UIColor(r: 252, g: 171, b: 13, a: 1)
    static let levelSixColor = UIColor(r: 246, g: 107, b: 15, a: 1)
    static let levelSevenColor = UIColor(r: 195, g: 38, b: 27, a: 1)
}

public struct TeamOneColor {
    public let backgroundDefault = UIColor(r: 253, g: 253, b: 253, a: 1)
    public let mainColor = UIColor(r: 0, g: 174, b: 228, a: 1)
    public let mainlightColor = UIColor(r: 241, g: 252, b: 255, a: 1)
    public let background = UIColor(r: 249, g: 250, b: 252, a: 1)
    public let point = UIColor(r: 214, g: 37, b: 70, a: 1)
    public let pointTwo = UIColor(r: 247, g: 205, b: 213, a: 1)
    public let grayscaleEight = UIColor(r: 66, g: 66, b: 66, a: 1)
    public let grayscaleSeven = UIColor(r: 97, g: 97, b: 97, a: 1)
    public let grayscaleFive = UIColor(r: 158, g: 158, b: 158, a: 1)
    public let grayscaleTwo = UIColor(r: 238, g: 238, b: 238, a: 1)
    public let grayscaleOne = UIColor(r: 245, g: 245, b: 245, a: 1)
    public let white = UIColor(r: 253, g: 253, b: 253, a: 1)
    public let bgColor = UIColor(r: 249, g: 250, b: 252, a: 1)
    public let transparent = UIColor(r: 0, g: 0, b: 0, a: 0.7)
    
}

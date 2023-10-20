//
//  UIFont+Extension.swift
//  DSKitTests
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit

public enum SansNeo: String {
    case largeTitle
    case title1
    case title2
    case body1
    case body2
    case body3
    case body4
    case button1
    case button2
    case caption1
    case caption2

    public var font: String {
        switch self {
        case .largeTitle:
            return "SpoqaHanSans-Bold"
        case .title1:
            return "SpoqaHanSans-Bold"
        case .title2:
            return "SpoqaHanSans-Regular"
        case .body1:
            return "SpoqaHanSans-Regular"
        case .body2:
            return "SpoqaHanSans-Bold"
        case .body3:
            return "SpoqaHanSans-Regular"
        case .body4:
            return "SpoqaHanSans-Bold"
        case .button1:
            return "SpoqaHanSans-Bold"
        case .button2:
            return "SpoqaHanSans-Regular"
        case .caption1:
            return "SpoqaHanSans-Regular"
        case .caption2:
            return "SpoqaHanSans-Regular"
        }
    }

    public var size: CGFloat {
        switch self {
        case .largeTitle:
            return 24
        case .title1:
            return 20
        case .title2:
            return 20
        case .body1:
            return 17
        case .body2:
            return 16
        case .body3:
            return 16
        case .body4:
            return 14
        case .button1:
            return 14
        case .button2:
            return 14
        case .caption1:
            return 12
        case .caption2:
            return 10
        }
    }
}

public extension UIFont {
    static func setFont(font: SansNeo) -> UIFont {
        guard let font = UIFont(name: font.font, size: font.size) else {
            fatalError("Font set Error")
        }

        return font
    }
}

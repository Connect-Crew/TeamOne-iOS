//
//  HashTag.swift
//  Domain
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit
import DSKit

public struct HashTag {
    public let title: String
    public let background: HashBackground
    public let titleColor: HashTagTitleColor
}

public enum HashBackground {
    case pink
    case gray

    public var image: UIImage? {
        switch self {
        case .gray: return .image(dsimage: .tagGray)
        case .pink: return .image(dsimage: .tagRed)
        }
    }
}

public enum HashTagTitleColor {
    case gray

    public var titleColor: UIColor {
        switch self {
        case .gray: return .teamOne.grayscaleSeven
        }
    }
}

//
//  HashTag.swift
//  Domain
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public struct HashTag: Hashable {
    public let title: String
    public let background: HashBackground
    public let titleColor: HashTagTitleColor
}

public enum HashBackground {
    case pink
    case gray

}

public enum HashTagTitleColor {
    case gray
}


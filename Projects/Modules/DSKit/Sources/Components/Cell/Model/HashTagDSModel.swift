//
//  HashTagDSModel.swift
//  DSKit
//
//  Created by Junyoung on 2/11/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct HashTagDSModel: Hashable {
    public let title: String
    public let tagColor: HashBackground
    
    public init(title: String, tagColor: HashBackground) {
        self.title = title
        self.tagColor = tagColor
    }
}

public enum HashBackground {
    case pink
    case gray
    case black
}

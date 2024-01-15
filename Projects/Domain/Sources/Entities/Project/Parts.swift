//
//  Parts.swift
//  Domain
//
//  Created by 강현준 on 1/15/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct Parts: Codable {
    public var key: String
    public var part: String
    public var category: String
    
    public init(key: String, part: String, category: String) {
        self.key = key
        self.part = part
        self.category = category
    }
}


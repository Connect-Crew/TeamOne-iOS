//
//  Recurit.swift
//  Domain
//
//  Created by 강현준 on 12/16/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public typealias Recurits = [Recruit]

public struct Recruit: Hashable {
    
    public var category: String
    public var part: String
    public var comment: String
    public var max: Int
    
    public init(category: String, part: String, comment: String, max: Int) {
        self.category = category
        self.part = part
        self.comment = comment
        self.max = max
    }
    
}

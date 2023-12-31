//
//  Recurit.swift
//  Domain
//
//  Created by 강현준 on 12/16/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public typealias Recurits = [Recurit]

public struct Recurit {
    /// 직군
    public var part: String

    public var comment: String

    public var max: Int

    public init(part: String, comment: String, max: Int) {
        self.part = part
        self.comment = comment
        self.max = max
    }
}

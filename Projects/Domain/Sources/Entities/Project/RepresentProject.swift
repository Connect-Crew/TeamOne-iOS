//
//  RepresentProject.swift
//  Domain
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct RepresentProject {
    public let id: Int
    public let thumbnail: String

    public init(id: Int, thumbnail: String) {
        self.id = id
        self.thumbnail = thumbnail
    }
}

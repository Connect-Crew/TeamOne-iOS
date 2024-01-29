//
//  AppliesListItem.swift
//  Domain
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct AppliesListItem {
    public let profile: String
    public let applies: Applies
    
    public init(profile: String, applies: Applies) {
        self.profile = profile
        self.applies = applies
    }
}

//
//  DSRepresentProject+Detail.swift
//  DSKit
//
//  Created by 강현준 on 2/14/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import UIKit

public struct DSRepresentProject_Detail {
    public let thumbnail: String
    public let title: String
    public let startDay: String
    public let endDay: String
    
    public init(thumbnail: String, title: String, startDay: String, endDay: String) {
        self.thumbnail = thumbnail
        self.title = title
        self.startDay = startDay
        self.endDay = endDay
    }
}

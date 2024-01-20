//
//  String+Extension.swift
//  Core
//
//  Created by 강현준 on 1/15/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public extension String {
    func bannerUrlToName() -> String {
        let components = self.components(separatedBy: "/")
        return components.last ?? ""
    }
}

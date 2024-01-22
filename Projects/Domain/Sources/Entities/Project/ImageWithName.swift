//
//  ImageWithName.swift
//  Domain
//
//  Created by 강현준 on 1/15/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import UIKit

public struct ImageWithName {
    public let name: String
    public let image: UIImage
    
    public init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    public init(image: UIImage) {
        self.name = UUID().uuidString
        self.image = image
    }
}

extension ImageWithName: Equatable {
    public static func == (lhs: ImageWithName, rhs: ImageWithName) -> Bool {
        return lhs.name == rhs.name
    }
}

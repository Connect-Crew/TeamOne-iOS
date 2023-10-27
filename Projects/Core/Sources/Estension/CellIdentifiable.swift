//
//  CellIdentifiable.swift
//  CoreTests
//
//  Created by 강현준 on 2023/10/27.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public protocol CellIdentifiable {
    static var identifier: String { get }
}

public extension CellIdentifiable {
    static var identifier : String { "\(self)" }
}

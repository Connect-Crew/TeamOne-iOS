//
//  WishResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/28/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct WishResponseDTO: Codable{
    let message: String
    
    public init(message: String) {
        self.message = message
    }
}

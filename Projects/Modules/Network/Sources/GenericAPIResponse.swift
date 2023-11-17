//
//  GenericAPIResponse.swift
//  Network
//
//  Created by 강현준 on 2023/11/15.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum GenericAPIResponse<Success: Decodable, Error: Decodable> {
    case success(Success)
    case failure(Error)
}

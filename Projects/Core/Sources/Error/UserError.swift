//
//  UserError.swift
//  Core
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum UserError: Error {
    case loadFail

    var errorDiscription: String {
        switch self {
        case .loadFail: return "유저 정보를 불러오는데 실패했습니다."
        }
    }
}

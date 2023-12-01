//
//  ProjectError.swift
//  Core
//
//  Created by 강현준 on 2023/11/26.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public enum ProjectError: Error {
    case loadFail


    var errorDiscription: String {
        switch self {
        case .loadFail: return "프로젝트 정보를 불러오는데 실패했습니다."
        }
    }
}

public enum ApplyError: Error {
    case recruitComplete
    case recruitOthers

    var errorDiscription: String {
        switch self {
        case .recruitComplete: return "모집이 완료되었습니다"
        case .recruitOthers: return "404 Not Fount"
        }
    }
}

//
//  ProjectReportRequestDTO.swift
//  Data
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

public struct ProjectReportRequestDTO: Codable {
    let projectId: Int
    let reason: String
}

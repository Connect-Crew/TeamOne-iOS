//
//  ProjectRecruitDTO.swift
//  Data
//
//  Created by 강현준 on 12/26/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

struct ProjectRecruitDTO: Codable {
    let part: String
    let comment: String
    let max: Int
    
    init(part: String, comment: String, max: Int) {
        self.part = part
        self.comment = comment
        self.max = max
    }
}

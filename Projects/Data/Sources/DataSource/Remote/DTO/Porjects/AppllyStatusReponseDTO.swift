//
//  ApplicantStateReponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/22/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

struct AppllyStatusReponseDTO: Codable {
    let applies: Int
    let current: Int
    let max: Int
    let comment: String
}

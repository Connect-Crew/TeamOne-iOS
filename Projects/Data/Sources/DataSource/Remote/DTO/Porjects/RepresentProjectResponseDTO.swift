//
//  RepresentProjectResponseDTO.swift
//  Data
//
//  Created by 강현준 on 1/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import Domain

struct RepresentProjectResponseDTO: Codable {
    let id: Int
    let thumbnail: String

    func toDomain() -> RepresentProject {
        return RepresentProject(
            id: self.id,
            thumbnail: self.thumbnail
        )
    }
}

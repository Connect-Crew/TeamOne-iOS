//
//  ProjectFavoriteResponseDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct ProjectFavoriteResponseDTO: Codable {
    let project: Int
    let myFavorite: Bool
    let favorite: Int

    func toDomain() -> Like {
        return Like(
            project: self.project,
            myFavorite: self.myFavorite,
            favorite: self.favorite
        )
    }
}

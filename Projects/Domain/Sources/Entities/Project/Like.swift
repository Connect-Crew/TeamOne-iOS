//
//  Like.swift
//  Domain
//
//  Created by 강현준 on 2023/11/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation

public struct Like {
    public let project: Int
    public let myFavorite: Bool
    public let favorite: Int

    public init(project: Int, myFavorite: Bool, favorite: Int) {
        self.project = project
        self.myFavorite = myFavorite
        self.favorite = favorite
    }
}

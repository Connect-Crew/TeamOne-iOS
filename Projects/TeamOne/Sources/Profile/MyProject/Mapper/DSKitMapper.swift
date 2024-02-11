//
//  DSKitMapper.swift
//  TeamOne
//
//  Created by Junyoung on 2/6/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation
import DSKit
import Domain

public extension MyProjects {
    func toDS() -> MyProjectsDSModel {
        return MyProjectsDSModel(
            id: self.id,
            title: self.title,
            thumbnail: self.thumbnail,
            region: self.region,
            online: self.online,
            careerMin: self.careerMin,
            careerMax: self.careerMax,
            createdAt: self.createdAt,
            state: self.state,
            favorite: self.favorite,
            myFavorite: self.myFavorite,
            category: self.category,
            goal: self.goal,
            recruitStatus: self.recruitStatus.map { $0.toDS() }
        )
    }
}

public extension RecruitStatus {
    func toDS() -> RecruitStatusDSModel {
        return RecruitStatusDSModel(
            category: self.category,
            part: self.part,
            partKey: self.part,
            comment: self.comment,
            current: self.current,
            max: self.max,
            applied: self.applied
        )
    }
}

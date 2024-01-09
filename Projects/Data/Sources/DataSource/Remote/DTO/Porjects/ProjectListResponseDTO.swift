//
//  ProjectListResponseDTO.swift
//  Data
//
//  Created by 강현준 on 2023/11/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import Domain

public struct ProjectListResponseDTO: Decodable {
    let id: Int
    let title: String
    let thumbnail: String?
    let region: String
    let online: Bool
    let careerMin, careerMax: String
    let createdAt: String
    let state: String
    let favorite: Int
    let myFavorite: Bool
    let category: [String]
    let goal: String
    let recruitStatus: [RecruitStatusResponseDTO]

    public func toDomain() -> SideProjectListElement {

        let recruitStatus = self.recruitStatus.map { $0.toDomain() }

        return SideProjectListElement(
            id: self.id,
            title: self.title,
            thumbnail: self.thumbnail,
            region: self.region,
            online: self.online,
            careerMin: self.careerMax,
            careerMax: self.careerMin,
            createdAt: self.createdAt,
            state: self.state,
            favorite: self.favorite,
            myFavorite: self.myFavorite,
            category: self.category,
            goal: self.goal,
            recruitStatus: recruitStatus
        )
    }
}

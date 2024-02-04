//
//  MyProjectsResponseDTO.swift
//  Data
//
//  Created by Junyoung on 2/4/24.
//  Copyright © 2024 TeamOne. All rights reserved.
//

import Foundation

import Domain

public struct MyProjectsResponseDTO: Codable {
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
}

public extension MyProjectsResponseDTO {
    func toDomain() -> MyProjects {
        return MyProjects(
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
            recruitStatus: self.recruitStatus.map { $0.toDomain() }
        )
    }
}


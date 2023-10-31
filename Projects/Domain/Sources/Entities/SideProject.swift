//
//  Project.swift
//  DomainTests
//
//  Created by 강현준 on 2023/10/30.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public struct SideProject {
    public let mainImage: UIImage?
    public let title: String?
    public let location: String?
    public let isExistedperiod: Bool
    public let startDate: String?
    public let endDate: String?
    public let hashTags: [HashTag]?
    public let totalTeamMember: Int
    public let currentTeamMember: Int
    public let parts: [Part]?
    public let isEmpty: Bool

    public init(
        mainImage: UIImage?,
        title: String?,
        location: String?,
        isExistedperiod: Bool,
        startDate: String?,
        endDate: String?,
        hashTags: [HashTag]?,
        totalTeamMember: Int,
        currentTeamMember: Int,
        parts: [Part]?,
        isEmpty: Bool) {
        self.mainImage = mainImage
        self.title = title
        self.location = location
        self.isExistedperiod = isExistedperiod
        self.startDate = startDate
        self.endDate = endDate
        self.hashTags = hashTags
        self.totalTeamMember = totalTeamMember
        self.currentTeamMember = currentTeamMember
        self.parts = parts
        self.isEmpty = isEmpty
    }

}

public struct HashTag {
    public let title: String
    public  let backgroundColor: String

    public init(title: String, backgroundColor: String) {
        self.title = title
        self.backgroundColor = backgroundColor
    }
}

public struct Part {
    public let part: String
    public let participants: Int

    public init(part: String, participants: Int) {
        self.part = part
        self.participants = participants
    }
}

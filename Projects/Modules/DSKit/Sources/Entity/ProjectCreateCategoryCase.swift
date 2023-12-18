//
//  ProjectCreateCategoryCase.swift
//  DSKit
//
//  Created by 강현준 on 12/12/23.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import Foundation
import UIKit

public enum ProjectCreateCategoryList: CaseIterable {
    case it
    case app
    case travle
    case ecommerce
    case community
    case education
    case healthLife
    case babyPet
    case love
    case game
    case food
    case finance
    case house
    case ai
    case others

    public var title: String {
        switch self {
        case .it: return "IT"
        case .app: return "앱서비스"
        case .travle: return "여행"
        case .ecommerce: return "쇼핑·이커머스"
        case .community: return "커뮤니티"
        case .education: return "교육"
        case .healthLife: return "건강·생활"
        case .babyPet: return "육아·반려동물"
        case .love: return "연애"
        case .game: return "게임"
        case .food: return "요식업"
        case .finance: return "금융"
        case .house: return "부동산·숙박"
        case .ai: return "인공지능"
        case .others: return "기타"
        }
    }

    public var image: UIImage? {
        switch self {
        case .it:
            return UIImage.image(dsimage: .CreateIT)
        case .app:
            return UIImage.image(dsimage: .createApp)
        case .travle:
            return UIImage.image(dsimage: .createTravel)
        case .ecommerce:
            return UIImage.image(dsimage: .createEcommerce)
        case .community:
            return UIImage.image(dsimage: .createCommunity)
        case .education:
            return UIImage.image(dsimage: .createEducation)
        case .healthLife:
            return UIImage.image(dsimage: .createHealthLife)
        case .babyPet:
            return UIImage.image(dsimage: .createBabyPet)
        case .love:
            return UIImage.image(dsimage: .createLove)
        case .game:
            return UIImage.image(dsimage: .createGame)
        case .food:
            return UIImage.image(dsimage: .createFood)
        case .finance:
            return UIImage.image(dsimage: .createFinance)
        case .house:
            return UIImage.image(dsimage: .createHouse)
        case .ai:
            return UIImage.image(dsimage: .createAi)
        case .others:
            return nil
        }
    }

    public var selectedLayerColor: CGColor {
        switch self {
        case .it:
            return UIColor.init(r: 1, g: 75, b: 146, a: 1).cgColor
        case .app:
            return UIColor.init(r: 133, g: 13, b: 111, a: 1).cgColor
        case .travle:
            return UIColor.init(r: 80, g: 171, b: 10, a: 1).cgColor
        case .ecommerce:
            return UIColor.init(r: 168, g: 141, b: 0, a: 1).cgColor
        case .community:
            return UIColor.init(r: 81, g: 78, b: 135, a: 1).cgColor
        case .education:
            return UIColor.init(r: 119, g: 25, b: 241, a: 1).cgColor
        case .healthLife:
            return UIColor.init(r: 4, g: 107, b: 51, a: 1).cgColor
        case .babyPet:
            return UIColor.init(r: 112, g: 83, b: 53, a: 1).cgColor
        case .love:
            return UIColor.init(r: 211, g: 17, b: 69, a: 1).cgColor
        case .game:
            return UIColor.init(r: 0, g: 128, b: 129, a: 1).cgColor
        case .food:
            return UIColor.init(r: 241, g: 133, b: 0, a: 1).cgColor
        case .finance:
            return UIColor.init(r: 0, g: 111, b: 233, a: 1).cgColor
        case .house:
            return UIColor.init(r: 240, g: 79, b: 155, a: 1).cgColor
        case .ai:
            return UIColor.init(r: 38, g: 53, b: 110, a: 1).cgColor
        case .others:
            return UIColor.init(r: 97, g: 97, b: 97, a: 1).cgColor
        }
    }

    public var selectedBackgroundColor: UIColor {
        switch self {
        case .it:
            return UIColor.init(r: 232, g: 244, b: 255, a: 1)
        case .app:
            return UIColor.init(r: 251, g: 218, b: 245, a: 1)
        case .travle:
            return UIColor.init(r: 235, g: 246, b: 266, a: 1)
        case .ecommerce:
            return UIColor.init(r: 255, g: 250, b: 221, a: 1)
        case .community:
            return UIColor.init(r: 229, g: 228, b: 240, a: 1)
        case .education:
            return UIColor.init(r: 237, g: 224, b: 255, a: 1)
        case .healthLife:
            return UIColor.init(r: 231, g: 254, b: 241, a: 1)
        case .babyPet:
            return UIColor.init(r: 242, g: 236, b: 229, a: 1)
        case .love:
            return UIColor.init(r: 253, g: 230, b: 236, a: 1)
        case .game:
            return UIColor.init(r: 231, g: 255, b: 255, a: 1)
        case .food:
            return UIColor.init(r: 255, g: 223, b: 207, a: 1)
        case .finance:
            return UIColor.init(r: 221, g: 237, b: 255, a: 1)
        case .house:
            return UIColor.init(r: 253, g: 236, b: 224, a: 1)
        case .ai:
            return UIColor.init(r: 226, g: 230, b: 245, a: 1)
        case .others:
            return UIColor.init(r: 242, g: 242, b: 242, a: 1)
        }
    }
}


//
//  Image+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public enum Tablist: Int, CaseIterable {
    case home
    case community
    case recruitment
    case myteam
    case profile

    public var title: String {
        switch self {
        case .home: return "홈"
        case .community: return "커뮤니티"
        case .recruitment: return "모집"
        case .myteam: return "나의 팀"
        case .profile:  return "마이페이지"
        }
    }
}

public enum DSKitImage {
    case homeSolid
    case communitySolid
    case recruitmentSolid
    case myteamSolid
    case profileSolid
    case homeline
    case communityline
    case recruitmentline
    case myteamline
    case profileline

    case slider
    case search

    case categoryall
    case categorycustomerservice
    case categorydesign
    case categorydevelop
    case categoryengineering
    case categorymarketing
    case categorymedia
    case categoryothers
    case categoryplanning
    case categorysales
    case categoryspecialize

    case categoryfillall
    case categoryfillcustomerservice
    case categoryfilldesign
    case categoryfilldevelop
    case categoryfillengineering
    case categoryfillmarketing
    case categoryfillmedia
    case categoryfillothers
    case categoryfillplanning
    case categoryfillsales
    case categoryfillspecialize

    var toName: String {
        switch self {
        case .homeSolid:
            return "home_solid"
        case .communitySolid:
            return "community_solid"
        case .recruitmentSolid:
            return "recruitment_solid"
        case .myteamSolid:
            return "myteam_solid"
        case .profileSolid:
            return "profile_solid"
        case .homeline:
            return "home_line"
        case .communityline:
            return "community_line"
        case .recruitmentline:
            return "recruitment_line"
        case .myteamline:
            return "myteam_line"
        case .profileline:
            return "profile_line"
        case .slider:
            return "slider"
        case .search:
            return "search"

        case .categoryall:
            return "category.all"
        case .categorycustomerservice:
            return "category.customerservice"
        case .categorydesign:
            return "category.design"
        case .categorydevelop:
            return "category.develop"
        case .categoryengineering:
            return "category.engineering"
        case .categorymarketing:
            return "category.marketing"
        case .categorymedia:
            return "category.media"
        case .categoryothers:
            return "category.others"
        case .categoryplanning:
            return "category.planning"
        case .categorysales:
            return "category.sales"
        case .categoryspecialize:
            return "category.specialized"

        case .categoryfillall:
            return "category.fill.all"
        case .categoryfillcustomerservice:
            return "category.fill.customerservice"
        case .categoryfilldesign:
            return "category.fill.design"
        case .categoryfilldevelop:
            return "category.fill.develop"
        case .categoryfillengineering:
            return "category.fill.engineering"
        case .categoryfillmarketing:
            return "category.fill.marketing"
        case .categoryfillmedia:
            return "category.fill.media"
        case .categoryfillothers:
            return "category.fill.others"
        case .categoryfillplanning:
            return "category.fill.planning"
        case .categoryfillsales:
            return "category.fill.sales"
        case .categoryfillspecialize:
            return "category.fill.specialized"
        }
    }
}

public extension UIImage {
    static func image(dsimage: DSKitImage) -> UIImage? {
        guard let image = UIImage(named: dsimage.toName, in: Bundle.module, compatibleWith: .none) else {
            return nil
        }

        return image
    }

    static let tabBar = TabBar()
}

public struct TabBar {
    public func loadSelectedImage(for tab: Tablist) -> UIImage? {
        switch tab {
        case .home:
            return UIImage.image(dsimage: .homeSolid)
        case .community:
            return UIImage.image(dsimage: .communitySolid)
        case .recruitment:
            return UIImage.image(dsimage: .recruitmentSolid)
        case .myteam:
            return UIImage.image(dsimage: .myteamSolid)
        case .profile:
            return UIImage.image(dsimage: .profileSolid)
        }
    }

    public func loadImage(for tab: Tablist) -> UIImage? {
        switch tab {
        case .home:
            return UIImage.image(dsimage: .homeline)
        case .community:
            return UIImage.image(dsimage: .communityline)
        case .recruitment:
            return UIImage.image(dsimage: .recruitmentline)
        case .myteam:
            return UIImage.image(dsimage: .myteamline)
        case .profile:
            return UIImage.image(dsimage: .profileline)
        }
    }
}


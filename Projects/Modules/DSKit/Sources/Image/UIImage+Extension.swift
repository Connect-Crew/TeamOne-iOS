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


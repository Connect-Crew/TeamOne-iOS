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
    case myteam
    case profile

    public var title: String {
        switch self {
        case .home: return "홈"
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
    case homeWriteButton

    case slider
    case search

    // MARK: - HomeCategories

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

    // MARK: - logo

    case logo

    // MARK: - 홈 셀

    case place
    case count
    case countDisable
    case heartline
    case heartsolid
    case tagGray
    case tagRed
    case upTwo
    case downTow
    case newTagBG
    case clock

    case homeHeader

    // MARK: - 로그인

    case appleLoginButtonBG
    case googleLoginButtonBG
    case kakaoLoginButtonBG
    case kakaoLoginExplain
    case backButtonImage
    case closeButtonX
    case checkNONOE
    case rightButton
    case checkOK


    // MARK: - 홈 네비게이션

    case notification
    case notificationnew

    // MARK: - Navigation

    case threedot

    // MARK: - ProjectDetail

    case baseProfile
    case leaderResponseRate
    case defaultIntroduceImage

    // MARK: - Common

    case complete
    case warinning
    case write
    case CheckBoxChecked
    case CheckBoxNotChecked

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

        case .homeWriteButton:
            return "homeWriteButton"

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
            
        case .place:
            return "place"
        case.tagGray:
            return "Tagbg_grey"
        case.tagRed:
            return "Tagbg_red"
        case .newTagBG:
            return "newTagbg"

        case .logo:
            return "임시로고"

        case .count:
            return "countAvailable"
        case .countDisable:
            return "countDisable"

        case .heartline:
            return "heart_line"
        case .heartsolid:
            return "heart_solid"

        case .upTwo:
            return "up_2"
        case .downTow:
            return "down_2"

        case .homeHeader:
            return "homeHeader"

        case .notification:
            return "notification"
        case .notificationnew:
            return "notification_new"

        case .threedot:
            return "threedot"

        case .baseProfile: return "baseProfile"
        case .leaderResponseRate: return "leaderResponseRate"
        case .defaultIntroduceImage: return "defaultIntroduceImage"

            // MARK: - 로그인

        case .appleLoginButtonBG: return "AppleLoginBackground"
        case .googleLoginButtonBG: return "GoogleLoginBackground-1"
        case .kakaoLoginButtonBG: return "KaKaoLoginBackground-2"
        case .kakaoLoginExplain: return "kakaoLoginExplain"

        case .backButtonImage: return "backButtonImage"
        case .closeButtonX: return "closeButtonX"
        case .checkNONOE: return "checkNONOE"
        case .rightButton: return "rightButton"
        case .checkOK: return "checkOK"
            
        // MARK: - Common
        case .complete: return "complete"
        case .warinning: return "warinning"
        case .write: return "write"

            // MARK: - CheckBox
        case .CheckBoxChecked: return "CheckBoxChecked"
        case .CheckBoxNotChecked: return "CheckBoxNotChecked"
        case .clock: return "Clock"
        }
    }
}

public extension UIImage {
    static func image(dsimage: DSKitImage) -> UIImage? {
        guard let image = UIImage(named: dsimage.toName, in: Bundle.module, compatibleWith: .none) else {
            print("DEBUG: image \(dsimage.toName) load 실패")
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
        case .myteam:
            return UIImage.image(dsimage: .myteamline)
        case .profile:
            return UIImage.image(dsimage: .profileline)
        }
    }
}

//
//  Image+Extension.swift
//  DSKit
//
//  Created by 강현준 on 2023/10/20.
//  Copyright © 2023 TeamOne. All rights reserved.
//

import UIKit

public enum DSKitImage {
    
    // MARK: - Tab
    
    case homeSolid
    case homeLine
    
    case myteamSolid
    case myteamLine
    
    case profileSolid
    case profileLine
    
    case notificationSolid
    case notificationSolidAlert
    case notificationLine
    
    case communitySolid
    case recruitmentSolid
    
    case communityline
    case recruitmentline
    
    
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
    case AppIcon
    
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
    case emptyLogo
    
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
    case warning
    case warningGray
    case write
    case CheckBoxChecked
    case CheckBoxNotChecked
    case checkBoxCheckedBlue
    case reset
    case up
    case down
    case compleProject
    
    // MARK: - ProjectCreate
    
    case CreateIT
    case createAi
    case createApp
    case createBabyPet
    case createCommunity
    case createEcommerce
    case createEducation
    case createFinance
    case createFood
    case createGame
    case createHealthLife
    case createHouse
    case createLove
    case createTravel
    
    // MARK: - PhotoSelect
    case photoSelect
    
    // MARK: - Delete
    case delete3
    case delete2
    case delete4
    
    // MARK: - Chat
    case send
    
    // MARK: - 꿀통
    case honeyLarge1
    case honeyLarge2
    case honeyLarge3
    case honeyLarge4
    
    case honeySmall1
    case honeySmall2
    case honeySmall3
    case honeySmall4
    
    case rightsmall
    
    // MARK: - arrow
    
    case arrowRightGray
    case arrowRightBlue
    
    case copy
    
    // MARK: - NotificaitonTap
    
    case chatbot
  
    // MARK: - Profile
    case myProject
    case submittedProject
    case favoriteProject

    
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
        case .homeLine:
            return "home_line"
        case .communityline:
            return "community_line"
        case .recruitmentline:
            return "recruitment_line"
        case .myteamLine:
            return "myteam_line"
        case .profileLine:
            return "profile_line"
        case .slider:
            return "slider"
        case .search:
            return "search"
        case .notificationSolid:
            return "notification_solid"
        case .notificationSolidAlert:
            return "notification_soli_alert"
        case .notificationLine:
            return "notification_line"
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
            return "logo"
        case .AppIcon:
            return "AppIcon"
            
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
        case .checkBoxCheckedBlue: return "checkBoxCheckedBlue"
            
            // MARK: - Common
        case .complete: return "complete"
        case .warning: return "warinning"
        case .warningGray: return "warningGray"
        case .write: return "write"
        case .clock: return "Clock"
        case .emptyLogo: return "EmptyLogo"
        case .reset: return "reset"
        case .compleProject: return "CompleProject"
            
            // MARK: - CheckBox
        case .CheckBoxChecked: return "CheckBoxChecked"
        case .CheckBoxNotChecked: return "CheckBoxNotChecked"
            
        case .up: return "up"
        case .down: return "down"
            
            // MARK: - ProjectCreate
            
        case .CreateIT: return "projectCreate_IT"
        case .createAi: return "projectCreate_Ai"
        case .createApp: return "projectCreate_App"
        case .createBabyPet: return "projectCreate_Baby_Pet"
        case .createCommunity: return "projectCreate_Community"
        case .createEcommerce: return "projectCreate_Ecommerce"
        case .createEducation: return "projectCreate_Education"
        case .createFinance: return "projectCreate_finanace"
        case .createFood: return "projectCreate_Food"
        case .createGame: return "projectCreate_Game"
        case .createHealthLife: return "projectCreate_HealthLife"
        case .createHouse: return "projectCreate_House"
        case .createLove: return "projectCreate_Love"
        case .createTravel: return "projectCreate_Travel"
            
            // MARK: - PhotoSelect
        case .photoSelect: return "PhotoSelected"
            
            // MARK: - Delete
        case .delete2: return "Delete2"
        case .delete3: return "Delete3"
        case .delete4: return "Delete4"
            // MARK: - Chat
        case .send: return "send"
            
        case .honeyLarge1: return "honey.large.1"
        case .honeyLarge2: return "honey.large.2"
        case .honeyLarge3: return "honey.large.3"
        case .honeyLarge4: return "honey.large.4"
        
        case .honeySmall1: return "honey.small.1"
        case .honeySmall2: return "honey.small.2"
        case .honeySmall3: return "honey.small.3"
        case .honeySmall4: return "honey.small.4"
            
            // MARK: - Arrow
        case .rightsmall: return "right.small"
        case .arrowRightGray: return "arrow.right.gray"
        case .arrowRightBlue: return "arrow.right.blue"
            
        case .copy: return "copy"
            
            // MARK: - NotificationTap
            
        case .chatbot: return "chatbot"

        case .myProject:
            return "line"
        case .submittedProject:
            return "small"
        case .favoriteProject:
            return "heart"

        }
    }
}

public extension UIImage {
    static func image(dsimage: DSKitImage) -> UIImage? {
        guard let image = UIImage(named: dsimage.toName, in: Bundle.module, compatibleWith: .none) else 
        {
            print("DEBUG: image \(dsimage.toName) load 실패")
            fatalError()
        }
        
        return image
    }
}

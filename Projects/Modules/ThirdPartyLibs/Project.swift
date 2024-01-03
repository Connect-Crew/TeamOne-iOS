//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "ThirdPartyLibs",
    targets: [.staticFramework],
    internalDependencies: [
        .SPM.RxCocoa,
        .SPM.RxRelay,
        .SPM.RxSwift,
        .SPM.RxKeyboard,
        .SPM.Swinject,
        .SPM.Then,
        .SPM.SnapKit,
        .SPM.Inject,
        .SPM.RxKakaoSDK,
        .SPM.FirebaseAnalytics,
        .SPM.FirebaseCrashlytics,
        .SPM.FirebaseDynamicLinks,
        .SPM.FirebaseMessaging,
        .SPM.GoogleSignIn,
        .SPM.Alamofire,
//        .Carthage.DropDown
    ]
)


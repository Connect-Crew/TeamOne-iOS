//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription
import ConfigPlugin
import EnvPlugin

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.6.0")),
    .remote(url: "https://github.com/Moya/Moya.git", requirement: .exact("15.0.0")),
    .remote(url: "https://github.com/Swinject/Swinject.git", requirement: .exact("2.8.3")),
    .remote(url: "https://github.com/devxoul/Then.git", requirement: .exact("3.0.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxKeyboard.git", requirement: .exact("2.0.1")),
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.6.0")),
    .remote(url: "https://github.com/krzysztofzablocki/Inject.git", requirement: .exact("1.2.4"))
], baseSettings: Settings.settings(
    configurations: XCConfig.framework
))

let carthage = CarthageDependencies([
//    .github(path: "layoutBox/FlexLayout", requirement: .exact("1.3.33")),
//    .github(path: "layoutBox/PinLayout", requirement: .exact("1.10.4")),
])

let dependencies = Dependencies(
    carthage: carthage,
    swiftPackageManager: spm,
    platforms: [.iOS]
)
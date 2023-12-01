//
//  Dependency+Library.swift
//  EnvPlugin
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription

public extension TargetDependency {
    enum SPM {}
    enum Carthage {}
}

public extension TargetDependency.SPM {
    static let Then = TargetDependency.external(name: "Then")
    static let Alamofire = TargetDependency.external(name: "Alamofire")
    static let Swinject = TargetDependency.external(name: "Swinject")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let RxRelay = TargetDependency.external(name: "RxRelay")
    static let RxKeyboard = TargetDependency.external(name: "RxKeyboard")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Inject = TargetDependency.external(name: "Inject")
    static let RxKakaoSDK = TargetDependency.external(name: "RxKakaoSDK")
    static let RxKakaoSDKAuth = TargetDependency.external(name: "RxKakaoSDKAuth")
    static let FirebaseCrashlytics = TargetDependency.external(name: "FirebaseCrashlytics")
    static let FirebaseMessaging = TargetDependency.external(name: "FirebaseMessaging")
    static let FirebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
    static let FirebaseDynamicLinks = TargetDependency.external(name: "FirebaseDynamicLinks")
    static let GoogleSignIn = TargetDependency.external(name: "GoogleSignIn")


}

public extension TargetDependency.Carthage {
    
}

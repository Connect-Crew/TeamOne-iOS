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
    static let Moya = TargetDependency.external(name: "Moya")
    static let Swinject = TargetDependency.external(name: "Swinject")
    static let RxSwift = TargetDependency.external(name: "RxSwift")
    static let RxCocoa = TargetDependency.external(name: "RxCocoa")
    static let RxRelay = TargetDependency.external(name: "RxRelay")
    static let RxKeyboard = TargetDependency.external(name: "RxKeyboard")
    static let SnapKit = TargetDependency.external(name: "SnapKit")
    static let Inject = TargetDependency.external(name: "Inject")
    static let RxKakaoSDK = TargetDependency.external(name: "RxKakaoSDK")
    static let RxKakaoSDKAuth = TargetDependency.external(name: "RxKakaoSDKAuth")
}

public extension TargetDependency.Carthage {
    
}

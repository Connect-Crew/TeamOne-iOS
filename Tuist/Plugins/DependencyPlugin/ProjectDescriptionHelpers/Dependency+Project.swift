//
//  Dependency+Project.swift
//  EnvPlugin
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription

public typealias Dep = TargetDependency

public extension Dep {
    
    struct Features {
        public struct Report {}
        public struct Splash {}
    }
    
    struct Modules {}
}

// MARK: - Root
public extension Dep {
    static let data = Dep.project(target: "Data", path: .data)
    static let domain = Dep.project(target: "Domain", path: .domain)
    static let core = Dep.project(target: "Core", path: .core)
}

// MARK: - Modules
public extension Dep.Modules {
    static let dsKit = Dep.project(
        target: "DSKit",
        path: .relativeToModules("DSKit")
    )
    
    static let TeamOneNetwork = Dep.project(
        target: "TeamOneNetwork",
        path: .relativeToModules("TeamOneNetwork")
    )
    
    static let thirdPartyLibs = Dep.project(
        target: "ThirdPartyLibs",
        path: .relativeToModules("ThirdPartyLibs")
    )
}

// MARK: - Features
public extension Dep.Features {
    static func project(name: String, group: String) -> Dep { .project(target: "\(group)\(name)", path: .relativeToFeature("\(group)\(name)")) }
    
    static let BaseFeatureDependency = TargetDependency.project(target: "BaseFeatureDependency", path: .relativeToFeature("BaseFeatureDependency"))
    
    static let RootFeature = TargetDependency.project(target: "RootFeature", path: .relativeToFeature("RootFeature"))
    static let SplashFeature = TargetDependency.project(target: "SplashFeature", path: .relativeToFeature("SplashFeature"))
    
}

//MARK: Splash
public extension Dep.Features.Report {
    static let group = "Report"
    
    static let Feature = Dep.Features.project(name: "Feature", group: group)
    static let Interface = Dep.project(target: "\(group)FeatureInterface", path: .relativeToFeature("\(group)Feature"))
}

public extension Dep.Features.Splash {
    static let group = "Splash"
    
    static let Feature = Dep.Features.project(name: "Feature", group: group)
    static let Interface = Dep.project(target: "\(group)FeatureInterface", path: .relativeToFeature("\(group)Feature"))
}

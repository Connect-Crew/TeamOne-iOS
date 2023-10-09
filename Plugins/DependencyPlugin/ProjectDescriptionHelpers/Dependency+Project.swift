//
//  Dependency+Project.swift
//  EnvPlugin
//
//  Created by 강현준 on 2023/10/06.
//

import ProjectDescription

typealias Dep = TargetDependency

public extension Dep {
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
    
    static let network = Dep.project(
        target: "Network",
        path: .relativeToModules("Network")
    )
    
    static let thirdPartyLibs = Dep.project(
        target: "ThirdPartyLibs",
        path: .relativeToModules("ThirdPartyLibs")
    )
}


